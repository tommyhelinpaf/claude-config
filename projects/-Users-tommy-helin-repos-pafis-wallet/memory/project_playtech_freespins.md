---
name: Playtech Freespins Integration
description: Nytt integrationsprojekt för Playtechs freespin-lösning. Preliminär feasibility-analys, blockers, öppna frågor. Tommy arbetar på detta över flera sessioner.
type: project
originSessionId: 6f93b9de-a23f-4422-9658-ffc10ae6a7ce
---
## Kontext

Tommy har precis avslutat Push Gaming freespin-consume-all-integrationen (se `project_consume_all.md`) och ska nu integrera **Playtech** freespins. Initial hypotes var att Playtech skulle följa samma consume-all-mönster som Push Gaming, men Playtechs API-docs (delade av Tommy 2026-04-22) visar ett annat flöde. **Tommy har inte accepterat consume-all-diskvalificeringen ännu** — vill själv verifiera att summary-req inte också stöds av Playtech.

**Why:** Detta är ett långvarigt projekt Tommy kommer jobba på över många sessioner. Memory måste bevara både den tekniska analysen OCH de öppna frågorna.

**How to apply:** Vid varje Playtech-relaterad session — läs denna fil först. Om Tommy frågar om summary vs real-time, TransferFunds, Spain compliance, eller blockers — detta är referens. Verifiera alltid mot aktuell API-dokumentation och källkod innan påståenden.

---

## Relaterade tjänster (identifierade 2026-04-22)

- `pafis-tx-playtechgoc-service` — EXISTERAR. Playtech GOC translator. Idag bara REAL_MONEY-bets, ingen bonus-hantering. `BetService.java:80` hårdkodad till `PAFISWalletMonetaryType.REAL_MONEY`. `GameRoundResultResource.java` hanterar resultat men inte bonus-grenar.
- `playtechgoc-backend-service` — EXISTERAR. Backend för Playtech GOC.
- `playtechgoc-bonus-service` — **FINNS INTE**. Måste byggas (eller utvidgas från backend-service) för assignment-flöde.
- `pafis-wallet` har Platform-enums PLAYTECH, PLAYTECHGOCSPAIN, PLAYTECHGOCSWITZERLAND i configs men ingen Playtech-specifik affärslogik.
- ⚠️ `pafis-bonus-service` **FINNS INTE LÄNGRE** (bekräftat av Tommy 2026-04-22). Mergats in i pbs. Gamla referenser i Confluence-guider och Jira-templates (t ex ECTFNI-152) ska tolkas som pbs-komponenter idag.

## Återanvändbar kunskap i Qdrant (cross-repo, cross-session)

Sökbart via Qdrant när du börjar nästa session:
- Bonus/freespins integration-checklista (Tommys personliga notes) — sök "bonus integration checklist"
- Services-karta + deployment-ordning — sök "freespin bonus integration services"
- Summary-req mönster A/B (Greentube vs Push Gaming/Playtech) — sök "summary request pattern freespins"
- ECTFNI-136 template + alla 30 template-stories — sök "ECTFNI bonus template stories"
- Confluence-guide "How to integrate Free Spins" (delvis outdated) — sök "confluence free spins guide"
- Korrigering: pafis-bonus-service är borta — sök "pafis-bonus-service correction"
- Session-start-arbetsflöde för bonus-projekt — sök "session start bonus integration workflow"

---

## Real-time per-bet vs summary-request — ÖPPEN FRÅGA

**Min preliminära tolkning av API-docsen (ifrågasatt av Tommy):**
- Bet-requests kommer per freespin i real-time. Docsen säger "The reduced free spin count is always -1 because one free spin is allowed at a time".
- `TransferFunds` används bara för pending winnings/wagering requirement — inte som consume-summary av förbrukade freespins.
- Det skulle göra det till Rubyplay-mönstret (per-bet realtime), inte Push Gaming-mönstret (summary cleardown).

**Tommys invändning (2026-04-22):**
- Playtech har sagt att man kan **stänga av möjligheten för freespins att expirera utanför spelsession**. Det öppnar för att consume-all-mönstret ändå kan fungera.
- Båda flöden (real-time per-bet OCH summary) kan potentiellt stödjas av Playtech — behöver verifieras närmare.
- **Denna fråga är inte avgjord.** Tommy ska själv undersöka närmare. Antag inte att det bara är per-bet.

**Vad behöver verifieras:**
- Kan Playtech konfigureras att skicka en summary-request (motsv. Push Gamings `RGS_FREEROUND_CLEARDOWN`) istället för / utöver per-bet?
- Om expire-utanför-session är avstängt — innebär det bara att freespins måste konsumeras inom session, eller ändrar det också hur provider kommunicerar med oss?
- Gäller båda lägena per bonus-template eller per integration?

---

## Tekniska blockers (preliminär bedömning)

| Område | Status | Kommentar |
|---|---|---|
| pafis-wallet real-time per-bet freespin withdraw | 🟢 Klart | `RoService.java:59-67` default:ar 1 unit per consume. Fungerar som för Rubyplay. |
| pbs-reward-service partial consume | 🟢 Klart | Stödjs redan |
| pafis-wallet consume-all (summary) | 🟢 Klart | Endpoint `withdrawSummaryConsumeAll` finns nu (från Push Gaming-PR #814). Återanvändbar om Playtech går summary-vägen. |
| `pafis-tx-playtechgoc-service` — bonus-gren | 🟡 Ny utv. | Behöver hantera `type=BONUS` i Bet, rutning till bonus-withdraw |
| `playtechgoc-bonus-service` | 🔴 Ny tjänst | Måste byggas för assignment (`GiveFreeSpins`), `NotifyBonusEvent`-mottagning, program/direct-reward-logik |
| TransferFunds-endpoint (translator + wallet) | 🔴 Ny utv. | Bara om pending-winnings eller wagering-mode används |

---

## Spain compliance — preliminär bedömning

- **Spend-only freespins:** Fungerar troligen via befintlig `SpanishGameSessionService.registerBet()` (samma path som Rubyplay). Freespin-värdet finns i Bet-requesten (`bonusChanges.freeSpinChange.value`), så wallet har det i tid för Spanish event.
- **Pending winnings / Wagering-varianterna:** Potentiell Spain-blocker — `TransferFunds` sker "outside of the game round" enligt Playtechs egna docs. Kan komma utan aktiv spansk session → `getLatestGameSession()` skulle kasta `NoActiveGamingSessionException`. Timestamp-fabricering finns bara på consume-all-pathen idag.
- **Om summary-req-läget aktiveras** (Tommys hypotes): Befintlig consume-all-logik från Push Gaming kan potentiellt återanvändas — inklusive 3-stegs Spain session-resolution.
- **FREESPIN1 (värde okänt till bet-tid):** Inte en blocker — Playtech skickar värdet i Bet-requesten.

---

## Beroende på Playtech (måste verifieras med providern)

- Kan vi sätta eget assignment-ID eller får vi bara tillbaka deras (då krävs prefix för uniqueness mellan providers)?
- Idempotens på `GiveFreeSpins` vid retry — finns kontroll-endpoint eller idempotency-key?
- Stödjer API återanvändbara bonus-program (multipla assignments per player + program)?
- Direkt-reward vs bonus-program på provider-sida — vilken modell stöds?
- Kan bet-levels hämtas per game i alla relevanta valutor (inkl EUR för ES)?
- **[Tommys fråga]** Kan API:et konfigureras för summary-request flöde, och/eller är real-time per-bet det enda läget?
- Konfigurerbar expire-policy inom/utanför spelsession — bekräftat från Playtech

---

## Playtech API-kärna (från docs 2026-04-22)

**Freespin-typer:**
- FREESPIN1: värde per game, känns bara till vid bet-tid
- FREESPIN2: pre-determined värde(n), upp till 4 val

**Payout-lägen:**
- Spend-only: vinster direkt till operator wallet (normala Win-requests per spinn)
- Pending winnings: vinster hålls på Playtech-sidan till bonusen är klar, sedan `TransferFunds`
- Wagering requirement: vinster hålls till wagering uppfyllts, sedan `TransferFunds`

**Key fields i Bet-requesten:**
- `internalFundChanges.type=BONUS` — signalerar bonus-bet
- `bonusChanges.freeSpinChange.value` — monetärt värde på aktuell spinn
- `bonusChanges.freeSpinChange.count` — alltid -1 för freespin (en i taget)
- `bonusInstanceCode` — Playtech-sidans bonus-instans-ID (deprecated, use `BonusInfo`)
- `BonusInfo` — ny struktur för bonus-källa

**Lifecycle-events:**
- `GiveFreeSpins` — vi → Playtech: tilldela freespins
- `NotifyBonusEvent` (optional) — Playtech → oss: `ACCEPTED` / `REMOVED`
- `TransferFunds` — Playtech → oss: flytta held winnings (inte per spinn)
- `RemoveBonus` — vi → Playtech: ta bort bonus

---

## Nästa steg

1. Tommy ska verifiera med Playtech om summary-req-flöde går att konfigurera
2. Avgöra payout-läge (spend-only rekommenderas för att minimera Spain-risk) — men beroende av Playtechs stöd
3. Om consume-all-vägen visar sig funka: återanvänd `withdrawSummaryConsumeAll`-endpointen från Push Gaming-arbetet
4. Om per-bet: ny bonus-gren i `pafis-tx-playtechgoc-service`, ny eller utvidgad `playtechgoc-bonus-service`
5. Oavsett: bygg bonus-service för assignment-sidan (`GiveFreeSpins`)
