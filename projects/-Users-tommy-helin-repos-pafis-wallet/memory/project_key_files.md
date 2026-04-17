---
name: Key Files for Consume All Solution
description: Map of all files created/modified for the consume-all feature in pafis-wallet
type: project
---

## New Files
- `model/WithdrawConsumeAllReprocessRequest.java` - Entity for reprocess table
- `repository/WithdrawConsumeAllReprocessRequestRepository.java` - CrudRepository with `findOlderThan` query
- `service/WithdrawConsumeAllReprocessService.java` - CRUD service for reprocess table (replaces old SpanishGameSessionRetryService)
- `service/WithdrawConsumeAllReprocessJob.java` - Scheduled retry job (@Profile("jobs"), every 5 min)
- `gateway/SpanishGameSessionClient.java` - Added `getSessionAtTime` Feign method for new slotsession endpoint

## Modified Files
- `rest/TransactionResource.java` - New endpoint + catch for recoverable errors + save reprocess row
- `service/SpanishGameSessionService.java` - 3-step session resolution for consume-all
- `service/WithdrawService.java` - Cleanup reprocess row on success
- `gateway/SpanishGameSessionGateway.java` - Added `getSessionByTimestamp` method
- `db/migration/R__10_wallet_setup.sql` - New `withdraw_consume_all_reprocess_request` table

## API Module
- `api/PAFISWalletWithdrawSummaryConsumeAllRequest.java` - Request DTO (extends PAFISWalletRequest)

## Tests Need Updating
- Constructor changes in TransactionResource (added RoService, PlayerService, WithdrawConsumeAllReprocessService)
- Constructor changes in WithdrawService (added WithdrawConsumeAllReprocessService)
- Constructor changes in SpanishGameSessionService (added WithdrawConsumeAllReprocessService)
- SonarCloud coverage at 26.8%, needs ≥80% on new code
