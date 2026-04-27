---
name: Consume All Flows and Design Decisions
description: All failure flows, edge cases, compliance requirements, and design rationale for the consume-all freespin solution
type: project
originSessionId: 10075cb1-fd9a-47bd-b18f-6c216608b87b
---
## 9 Failure Flows

1. **Happy case** - Use existing get-session logic in WithdrawService. If expired session, continue with fabricated valid timestamp for consumeAll case.
2. **First req fails** - Catch in consumeAll endpoint saves to reprocess table. Only for recoverable errors (non-PafServiceBusinessException).
3. **Retry fails** - Catch updates session if resolved. Throws exception. Provider or scheduled job retries.
4. **Retry never comes from provider** - WithdrawConsumeAllReprocessJob retries every 5min. Picks up rows older than 5min.
5. **Late first request** - Will never get 100% correct session since player may have started new session. Must use latest session even if wrong. Fabricate timestamp to fit within session window.
6. **Race condition** - Two requests arrive simultaneously. A gets pessimistic lock first, consumes OK. B gets lock, finds completed transaction, returns idempotency response.
7. **Idempotency** - Same req later gets same units/amount from PBS (getRewardInfoWithPlayerStepId returns original values, not consumed). Existing withdraw idempotency returns rebuilt response from transaction.
8. **Slotsession down** - New endpoint getSessionByTimestamp used when retry row exists but no session was saved (slotsession was down during first failure). Falls back to latest session if no session found at timestamp.
9. **Retry table down** - Just throws exception. Provider retry treated as late first request. Even if wallet transaction exists, doesn't matter.
10. **Sen provider-retry med expired ticket** (upptäckt i prod 2026-04-26) - Provider retryar timmar/dygn senare via egen recon. Translator's `validate(...)` med `ignoreTokenException=true` returnerar null → siteSessionId=null på wallet-requesten. Wallet processar OK men BonusWithdraw publiceras med siteSessionId=null. Producer-v3 GoC-processor kraschar på `requireNonNull(siteSessionId)` → eventet droppas tyst i Snowflake. Se project_producer_v3_retry_gap.md.

## Spanish Session 3-Step Resolution (SpanishGameSessionService)

1. **Cached session** from reprocess row → use directly, set timestamp from row
2. **Session by timestamp** → new slotsession endpoint `GET /v2/players/{id}/session?at=<ISO-8601>`. No fabrication needed (timestamp was valid within that session by definition)
3. **Latest session fallback** → get latest session, fabricate timestamp if outside session window (startTime+1s or endTime-1s)

## Compliance Requirements (Spanish Market)

- ComplianceTech OK with using latest game session if session expired (e.g. late request)
- Most important: `external_timestamp` in BetsPlacedWithFreeSpinInSpanishGameSession must be within duration period of the chosen game session
- `spanishGameSessionId` can be from a session player wasn't playing in - compliance accepts this as long as timestamp fits
- Timestamp fabrication is acceptable - we log warning when it happens

## Key Design Rationale

- **Why playerStepId for bindingRef/eventId**: Unique per bonus reward, stable across provider retries. Provider rgsTxnId changes between retries breaking idempotency. Greentube uses same pattern.
- **Why new endpoint instead of modifying withdraw**: Amount is critical field, can't be nullable. Withdraw already overloaded with conditional logic. Clean separation.
- **Why wallet fetches from PBS (not translator)**: Avoids exposing PBS to translators. Keeps translators simple (only call wallet + auth). Amount unknown to provider for Push Gaming/Playtech.
- **Why PafServiceBusinessException = unrecoverable**: All validation/business errors (InvalidInput, BlockedGame, InsufficientFunds, etc.) extend PafServiceBusinessException. These are deterministic failures provider must handle manually. Everything else (timeouts, network, circuit breaker, DB) is potentially recoverable.
- **Why no fabrication after getSessionByTimestamp**: If slotsession returns a session for a timestamp, that timestamp was by definition valid within that session.
- **Why reprocess table stores full request data**: PBS fetch can fail before wallet transaction is created. Without full request data in reprocess table, scheduled job can't rebuild the request. Self-sufficient reprocessing regardless of failure state.

## Translator Service (pafis-tx-pushgaming-service)

- `RGS_FREEROUND_CLEARDOWN` = summary request sent after all freespins played. Contains total win amount.
- `rgsActionId` on cleardown = bonusId = maps to PBS playerStepId
- Flow: CleardownService calls wallet consumeAll (withdraw) → then normal deposit with win amount
- Event IDs: `CLEARDOWN-{playerStepId}` for withdraw, `CLEARDOWN-WIN-{playerStepId}` for deposit
- Deposit is NOT a summary deposit, just a normal deposit after the summary withdraw
- Won't compile until wallet PR merged and new API jar published to Nexus

## PR Status

- PR #814 on pafis-wallet, branch IG-10032-new-consume-all-endpoint
- Reviewers: Nico Punzalan, Adam Skowronek
- Nico's feedback (addressed): rename to WithdrawConsumeAll*, broader reprocess table, narrow exception catching, store full request in reprocess table
- SonarCloud coverage failing (26.8% vs 80%) - tests need writing/fixing
- Wallet API jar auto-publishes on merge to master (GitHub Actions, base-version 4.1)
