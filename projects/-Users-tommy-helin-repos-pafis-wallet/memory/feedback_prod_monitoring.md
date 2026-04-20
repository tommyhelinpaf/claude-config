---
name: Erbjud Datadog-kontroll efter prod-deploy
description: Påminn alltid om att jag kan övervaka tjänsten i Datadog direkt efter en prod-deploy
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Vid varje prod-deploy av en kritisk tjänst — erbjud alltid att göra en Datadog-genomgång direkt efter deploy.

**Why:** pafis-wallet påverkar alla spel (plånbok), och Tommy vill ha bekräftelse att uppstart, migration och kritiska endpoints fungerar korrekt.

**How to apply:** När Tommy nämner att han ska deploya eller har deployat till prod, säg: "När du har mergat — skriv 'mergat, kolla [tjänst]' så kör jag en Datadog-genomgång direkt."

Kontrollera alltid:
1. ECS-uppstart — ingen crash loop, rätt version aktiv
2. Flyway — migration körde OK, nya tabeller skapade
3. Error rate på kritiska endpoints (withdraw, deposit) vs baseline
4. Hälsostatus — actuator/health, circuit breakers
