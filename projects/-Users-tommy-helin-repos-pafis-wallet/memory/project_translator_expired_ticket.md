---
name: Translator Expired-Ticket → Null siteSessionId
description: När provider gör sen retry (timmar/dygn senare) har spelarens auth-ticket ofta expirerat. Translator returnerar null siteSessionId, vilket propagerar till wallet och vidare till business-events.
type: project
originSessionId: 10075cb1-fd9a-47bd-b18f-6c216608b87b
---
## Mönster
Translators (pafis-tx-pushgaming-service, sannolikt fler) anropar `AuthenticationService.validate(token, playerId, key, ignoreTokenException=true, false)` på cleardown/close/cancel/deposit. Vid expired/invalid ticket fångas exception och `null` returneras.

Detta null sätts som `siteSessionId` på consume-all/withdraw/deposit-requests till wallet. Wallet har ingen fallback-logik för siteSessionId (bara för spanishGameSessionId via 3-stegs resolution). Resultat: BonusWithdraw-event till Kafka har `siteSessionId=null` även när `spanishGameSessionId` är satt.

## Verifierat
- 2026-04-26 prod-incident: Push Gaming retryade RGS_FREEROUND_CLEARDOWN 5 dygn efter original (deras egen recon). Ticketen var expired → null siteSessionId hela vägen ner.

**Why:** Provider-retries är inte synkade med spelarens session-livslängd. `ignoreTokenException=true` finns just för att vi vill acceptera dessa late requests (idempotency/data-integritet) — inte 401:a dem.

**How to apply:**
- När du designar/reviewar något som beror på siteSessionId i consume-all/summary/late-flow: anta att det KAN vara null. Validera downstream (producer + Snowflake-schema) tål det.
- Lägger du till en ny translator som har ignoreTokenException=true: dokumentera att siteSessionId blir nullable i den path:en.
- Vid eventdesign: behandla siteSessionId som optional för bet-event som hör till summary-requests (bonus, freespins). Kräver nya nullable-typer i wallet-eventapi och uppdaterad Snowflake-schema.
