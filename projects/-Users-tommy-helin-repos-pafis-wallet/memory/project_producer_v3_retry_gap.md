---
name: Producer-v3 Retry Gap (Silent Snowflake Drops)
description: Wallet's reprocess-table skyddar bara wallet-laget; pafis-business-events-producer-v3 droppar NPE-event tyst. Korrekt wallet-state betyder INTE korrekt Snowflake-data.
type: project
originSessionId: 10075cb1-fd9a-47bd-b18f-6c216608b87b
---
## Faktum
- Wallet's `withdraw_consume_all_reprocess_request` retryar bara fel på wallet-endpointen. Failar Kafka-konsumtionen i `pafis-business-events-producer-v3` finns ingen retry — eventet är förlorat.
- `AbstractTransactionConsumerService` klassar `NullPointerException` och `DuplicateEventException` som `isUnrecoverableException` → `ack.acknowledge()` → tyst drop. Bara `PersistenceException` retryas.
- `GameOfChanceBonusWithdrawProcessor.sendBetsPlacedWithFreeSpinInSpanishGameSession` har `requireNonNull(event.getSiteSessionId(), ...)`. `GameOfChanceDepositProcessor` har **inte** — den tar `event.getSiteSessionId()` som det är. Så bet-event kraschar på null siteSessionId, win-event går igenom. Inkonsistens som ger trasig Snowflake-rapport även när wallet-transaktion finns.
- Samma `requireNonNull` finns även på `sendBetPlacedWithFreeSpinInSpanishGameSession` (per-bet) och i `sendJackpotContributedWithBet`.

**Why:** Bekräftat i prod 2026-04-26 (player 8380456, binding 65596431). Push Gaming sen retry → siteSessionId=null → bet-event NPE i producer → Snowflake `betsplacedwithfreespininspanishgamesession` saknas, men `betswon` finns. Compliance-rapport blir fel.

**How to apply:**
- Vid arbete med consume-all/summary, partial consume eller någon flow där siteSessionId KAN vara null: kontrollera att producer-v3 hanterar null i den path:en innan deploy.
- Vid arbete i producer-v3: en `requireNonNull` i en processor = potentiell silent data loss. Föreslå hellre nullable-fält + warn-log.
- Vid PR-review av nya event-typer/processorer: kräv enhetlig null-hantering mellan deposit- och withdraw-processors (annars asymmetrisk Snowflake).
- Anand Srinivasa har föreslagit airflow-recon (matcha betswon mot bets-placed) för att fånga klassen i framtiden — stötta det.
