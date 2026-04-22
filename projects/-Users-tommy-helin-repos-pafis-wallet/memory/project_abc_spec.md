---
name: ABC process spec (Tommys personliga produktivitetssystem)
description: Tommys ABC-task-process i Apple Notes — struktur, regler, morgonmöte-flöde. Använd som referens vid framtida sessioner om ABC.
type: project
originSessionId: 1d8cb3f3-d5bf-483e-a1c2-1127e945a6ca
---
Tommy har ett ABC-task-system i Apple Notes. Detta är spec:en som vi kom överens om (Kandidat 1 implementerad 2026-04-22).

## Ytor i hans totala system

1. **ABC-note** (A/B/C/D-listor + Inbox) — actions
2. **Projektnotes** — en per projekt, fullkontext + subpunkter. Han lyfter en atomär subpunkt i taget till A, med projekt-prefix
3. **Morgonmöte-note** — daglig checklista
4. **Min tid daglig / vecka / månad** — principer, inte tasks
5. **Dagbok** — max 3 aktiva hälsosymptom + arkiv

## ABC-notens struktur

```
- [ ] 📥 INBOX          (on-the-go-fångst, ingen max-gräns, töms morgonmöte)
    - [ ] (nya saker)
- [ ] A                  (max 5 sub-punkter, ~3 privata riktmärke)
- [ ] B                  (max 5)
- [ ] C                  (max 5)
- [ ] D                  (backlog)
```

**Inbox-placering:** ÖVERST (inte nederst). Tommy öppnar noten på iPhone och landar naturligt i toppen — Inbox där = minimal scroll = minimal telefontid (viktigt pga huvudvärksrisk).

## Morgonmötes-rad (abc-steget)

Ordagrant som Tommy har den:
```
abc...................rensa inbox......max 3 privata i a.......max 5 totalt i b och c.....flytta ner alla andra..........flytta gjorda jobb-punkter till story "notes"........lita på att jag betar igenom punkter i a......så det flyttas upp från b och c......flytta aldrig upp punkt....förrän ny vecka.....ny månad.....eller alla punkter klara i a, b eller c
```

## Regler

**Max-gränser:** 5 i A, 5 i B, 5 i C. Inbox ingen gräns.

**Privat/jobb-mix i A:** ~3 privata riktmärke (inte hård regel). Gäller normal mode.

**Mode:**
- **Normal mode:** privat-lutande mix
- **Crunch mode** (jobb-deadline eller akut): jobb tar över helt tills löst

**On-the-go-fångst:** allt nytt på iPhone under dagen → Inbox (aldrig direkt till A). Morgonmötet sorterar nästa morgon.

**Inbox-processering:** varje Inbox-punkt → A / B / D / radera. Om A redan på 5 och ny punkt ska in: bumpa lägst prio ner.

**Promotion-regler:**
- B→A: bara när A tom
- C→B: bara vid veckoskifte
- D→C: bara vid månadsskifte, bara när C tom

**Arkivering:** klara jobb-punkter flyttas till "notes"-story (separat arkiv). Privata kan bara strykas.

## Framtida kandidater (ej beslutade än)

- **Kandidat 2:** Quick-win-slot i A (reserverad plats för 15-min-punkter, löser bortglömda småpunkter)
- **Kandidat 3:** Kalender-adaptiv dagskapacitet (3 vs 5 slots beroende på dag)
- **Kandidat 4:** D-segmentering (D-now / D-bucket / D-system — löser "bottensediment"-känslan)
- **Kandidat 5:** AI som regel-vakt — Tommy klistrar in listan, Claude validerar/omordnar enligt reglerna

## Viktiga designprinciper att respektera

- Håll allt enkelt (se feedback_simplicity_style.md)
- Inline-notation (`......`) före sub-checkboxar
- Respektera hans befintliga ord och formuleringar
- Minimal telefontid (huvudvärksgräns)
- 20-min pomodoro-gräns för sittande
