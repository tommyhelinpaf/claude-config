---
name: Consume All Freespin Summary Solution
description: Push Gaming/Playtech freespin consume-all implementation across wallet and translator services. Covers architecture, retry handling, Spanish session management.
type: project
---

## What
Implementing "consume all" freespin summary requests for Push Gaming (and later Playtech). Unlike Greentube which sends units consumed, Push Gaming sends one cleardown request after all freespins are used - wallet must fetch units/amount from PBS.

**Why:** Provider doesn't send bet amount or units. Wallet fetches from PBS via new `withdrawSummaryConsumeAll` endpoint.

**How to apply:** Any work on consume-all, summary requests, or Spanish session handling in this repo relates to this feature.

## Key Design Decisions
- New endpoint `withdrawSummaryConsumeAll` instead of modifying existing withdraw (avoids overloading existing flow)
- Wallet fetches units/amount from PBS `getRewardInfoWithPlayerStepId` before creating internal withdraw
- Translator (pafis-tx-pushgaming-service) calls new wallet endpoint for `RGS_FREEROUND_CLEARDOWN`, then sends normal deposit for win amount
- Uses `playerStepId` (from Push Gaming's `rgsActionId`/bonusId) for both `bindingRef` and `eventId` (with prefix) to link withdraw+deposit and ensure idempotency across provider retries

## Retry/Reprocess Architecture
- Table: `wallet.withdraw_consume_all_reprocess_request` stores full request data (playerId, productId, currency, playerStepId, bindingRef, siteSessionId, businessEventCategory, timestamps, gameSessionId)
- On recoverable failure: saves reprocess row (only for Spanish market requests, only non-PafServiceBusinessException)
- `WithdrawConsumeAllReprocessJob` (scheduled, @Profile("jobs")) retries every 5 min, self-sufficient from reprocess table (no dependency on wallet Transaction table)
- Cleanup: successful withdraw deletes reprocess row in finally block of WithdrawService

## Spanish Game Session Handling
Three-step fallback in `SpanishGameSessionService.getSpanishGameSessionForConsumeAll`:
1. Cached session from reprocess row (if retry with resolved session)
2. `getSessionByTimestamp` - new slotsession endpoint for when slotsession was down during first attempt
3. Latest session fallback + timestamp fabrication (if request was late from provider)

Timestamp fabrication: adjusts to fit within session's startTime/endTime window. Compliance OK with this.

## PR & Review Status (as of 2026-03-31)
- PR #814 on pafis-wallet, branch `IG-10032-new-consume-all-endpoint`
- Reviewers: Nico Punzalan (@npunzalan), Adam Skowronek (@AdamSkowronekPaf)
- Nico requested changes (addressed): broader reprocess table, narrower exception catching, rename from Spanish-specific to general consume-all naming
- SonarCloud failing on coverage (26.8% vs required 80%) - tests need updating
