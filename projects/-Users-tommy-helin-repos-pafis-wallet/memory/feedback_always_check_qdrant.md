---
name: Alltid kolla Qdrant innan "nej jag vet inte"
description: Innan jag svarar att jag inte vet/inte har info om något domän-/PAF-relaterat MÅSTE jag söka i Qdrant först
type: feedback
originSessionId: 6c3a7b8a-0974-46fc-8f40-414fa5e8a75c
---
Innan jag säger "nej", "jag vet inte", eller "jag har inte info om X" om något PAF-/domän-/integrationsrelaterat — kör ALLTID `qdrant-find` först. Gäller även korta one-word-svar.

**Why:** 2026-04-27 frågade Tommy om jag kunde Playtech freespins API. Jag svarade "Nej" utan att kolla Qdrant — trots att jag hade en grundlig API-mapping lagrad där (giveFreeSpins, removeBonus, transferFunds, Spain/Sweden/Switzerland-regler etc., verifierad 2026-04-23). Tommy blev (rättmätigt) irriterad. Min minnesinstruktion säger explicit att jag ska söka i Qdrant vid varje task som rör PAF-tjänster — jag hoppade över det för att svaret kändes "snabbt".

**How to apply:**
- Innan jag avfärdar att jag har info om en PAF-tjänst, integration, provider, repo eller domän → kör `qdrant-find` med relevanta termer.
- Gäller även för förkortade/korta svar ("ja"/"nej", "1 ord"). Korthet är inget skäl att hoppa över sökning.
- Tolka aldrig en fråga snävare än den ställs utan att verifiera. "Playtech freespins API" = sök på det, inte avfärda för att jag tolkar "fulla" strikt.
- Om sökning ger träffar men jag är osäker på täckningen → svara med vad jag faktiskt har, inte ett blankt "nej".
