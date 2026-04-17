---
name: Push Gaming Translator Service
description: Changes made to pafis-tx-pushgaming-service for consume-all cleardown flow
type: project
---

## Translator Repo
Path: `/Users/tommy.helin/repos/pafis-tx-pushgaming-service`

## Changes Made
- `CleardownService.java` - handles `RGS_FREEROUND_CLEARDOWN` action type
  - Step 1: calls wallet's `withdrawSummaryConsumeAll` with `PAFISWalletWithdrawSummaryConsumeAllRequest`
  - Step 2: normal deposit with win amount from provider
  - Uses `playerStepId` (from `rgsActionId`) for `bindingRef` and `eventId` (prefixed with `CLEARDOWN-` / `CLEARDOWN-WIN-`)
- `TransactionService.java` - routes `RGS_FREEROUND_CLEARDOWN` to `cleardownService.handleCleardown()`
- `WinService.java` - removed broken `handleFreeSpinsWin()`, only `handleWin()` remains
- `ActionType.java` - has `RGS_FREEROUND_CLEARDOWN` enum value

## Blocked On
Won't compile until wallet PR #814 is merged and new `pafis-wallet-service-api` jar is published to Nexus. The jar is auto-published when wallet PR merges to master (GitHub Actions pipeline with base-version 4.1).

**How to apply:** Update pom.xml dependency version in translator after wallet jar is published.
