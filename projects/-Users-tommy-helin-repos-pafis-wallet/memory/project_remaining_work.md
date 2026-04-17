---
name: Remaining Work Items
description: What's left to do for the consume-all solution as of 2026-03-31
type: project
---

## Wallet (pafis-wallet) - PR #814

- [ ] Fix tests for SonarCloud coverage ≥80% on new code. Key constructors changed:
  - TransactionResource: added RoService, PlayerService, WithdrawConsumeAllReprocessService
  - WithdrawService: added WithdrawConsumeAllReprocessService
  - SpanishGameSessionService: added WithdrawConsumeAllReprocessService
- [ ] Old SpanishGameSessionRetryService.java deleted, replaced by WithdrawConsumeAllReprocessService.java
- [ ] Monitoring for old rows in reprocess table (deferred, not blocking)
- [ ] Consider adding consumeAll flag to PAFISWalletRelevantOffer (deferred, not blocking)

## Translator (pafis-tx-pushgaming-service)

- [ ] Update pom.xml with new wallet API jar version after wallet PR merges
- [ ] Verify CleardownService compiles with new wallet API
- [ ] Tests for CleardownService

## Not Doing Now
- Scheduled retry monitoring/alerting (ops task, provider retries + manual weekly reconciliation covers this)
- Strategy column on reprocess table (delete completed rows instead)
- consumeAll param on RelevantOffer (do when actually needed)
