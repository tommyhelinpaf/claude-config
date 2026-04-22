---
name: Playtech Freespins — Öppna frågor och verifieringspunkter
description: Checklista med frågor Tommy behöver svar på (från Playtech eller egen undersökning) innan Playtech freespin-integrationen kan designas klart
type: project
originSessionId: 6f93b9de-a23f-4422-9658-ffc10ae6a7ce
---
## Öppna frågor för Tommy / Playtech

**Why:** Playtech freespin-integrationen kan gå två olika tekniska vägar (per-bet eller summary) och valet påverkar både arkitektur och Spain-compliance. Dessa frågor måste besvaras innan designen låses.

**How to apply:** Uppdatera denna fil när frågor besvaras. När en fråga är stängd, flytta svaret till `project_playtech_freespins.md` och ta bort den härifrån.

---

## Till Playtech

1. **Summary-req stöd** — Kan ert API konfigureras att skicka en summary-request efter att alla freespins är konsumerade (liknande Push Gamings `RGS_FREEROUND_CLEARDOWN`) istället för eller utöver Bet-request per spinn?
2. **Expire-policy** — Bekräfta att expire utanför spelsession kan stängas av per bonus-template. Vad händer med oanvända freespins istället — expire vid session-slut?
3. **Spend-only konfig** — Kan spend-only freespins konfigureras per bonus-template?
4. **Assignment-ID** — Kan vi sätta eget unikt ID vid `GiveFreeSpins`, eller får vi bara ett provider-genererat ID tillbaka?
5. **Idempotency** — Finns kontroll-endpoint eller idempotency-key för `GiveFreeSpins`? (Behövs för retries utan duplicerad tilldelning)
6. **Återanvändbara program** — Stödjs multipla assignments per spelare + program?
7. **Direkt-reward vs bonus-program** — Vilken modell stöds? Behöver vi anropa deras `createProgram`-liknande endpoint eller kan det hoppas?
8. **Bet-levels** — Kan vi hämta bet-levels per game i alla relevanta valutor (inkl. EUR för Spain)?
9. **Regulerade marknader** — Är Spain (ES), Sverige (SE), Schweiz (CH), Estland (EE), Lettland (LV), Åland (AX) och Finland (FI) stödda av er freespin-lösning?
10. **FREESPIN1 vs FREESPIN2** — Vilken typ rekommenderas för Spain? Har ni erfarenhet av vilket som lättast passar compliance-krav på transaktionsvärden?

---

## Till Tommy (egen undersökning)

- Kolla att vi fått senaste API-versionen (inte gammal PDF)
- Bekräfta att båda flödena (per-bet och summary) verkligen båda finns — min preliminära tolkning av docsen sade bara per-bet
- Kolla med compliance-team vad som gäller för Spain och Playtech specifikt
- Kolla med integration-arkitekt och manager om pending-winnings/wagering-spåren över huvud taget är aktuella eller om vi ska hålla oss till spend-only
- Kolla om det finns existerande Playtech-bonusintegration hos andra PAF-sidor eller tidigare Playtech-produkter som vi kan dra lärdomar från
