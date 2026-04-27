---
name: Freespins Pre-Test Checklist (PINT bonus events per plattform)
description: Innan freespins testas i CI eller prod för en ny plattform MÅSTE bonus events vara korrekt uppsatta i PINT för den plattformen. Malländring kräver mailgodkännande från comptech-teamet och Johan Ferm.
type: project
originSessionId: 10075cb1-fd9a-47bd-b18f-6c216608b87b
---
## Regel
Innan vi testar freespins-spel i CI eller prod för en plattform (Push Gaming, Playtech, framtida providers): bonus events i PINT MÅSTE vara konfigurerade för platform_id + product_id + market. Annars failar consume-all/withdraw med 422 `UNKNOWN_EVENT_TYPE` (event_type_id okänt).

Vid ändring av PINT-mall: skicka mail till comptech-teamet och Johan Ferm för godkännande innan deploy.

**Why:** Verifierat i prod 2026-04-21 — testkörning failade med 422 för razorshark/PUSHGAMINGSPAIN/event_type_id 1130 eftersom PINT inte hade events uppsatta. Resulterade i 5 dygns retry-storm + downstream Snowflake-incident (se project_producer_v3_retry_gap.md). Mallar styr compliance-rapportering → får inte ändras utan comptech-OK.

**How to apply:**
- Innan första testet i CI eller prod för ett nytt provider/platform/market-kombo: verifiera PINT-config explicit. Inkludera detta i pre-test-checklistan tillsammans med deploy-status, IAM/secrets, recon-monitorering.
- Malländring → mail till comptech-teamet + Johan Ferm → vänta in godkännande → tillämpa.
- Existerande prod-spel som bygger på samma mall är **inte i riskzon** vid mallförändring: freespins delas ut aktivt via backoffice → ingenting triggas spontant. Förutsatt att uppsättningen är korrekt finns inget retroaktivt brott.
- Om du är osäker på vilka event_type_ids som behövs för den nya providern: kolla logg för 422 `UNKNOWN_EVENT_TYPE` från första testförsöket — error_detail innehåller event_type_id.
