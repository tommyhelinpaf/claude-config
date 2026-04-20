---
name: gh repo list är inte komplett
description: gh repo list pafcloud returnerar inte alla repos — bekräfta aldrig att ett repo saknas baserat på detta
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Påstå aldrig att ett repo inte existerar bara för att `gh repo list pafcloud --limit 100` inte returnerar det. Listan är inkomplett.

**Why:** pbs-program-service saknades i listan trots att det existerar på https://github.com/pafcloud/pbs-program-service — Tommy fick rätta detta manuellt.

**How to apply:** Om ett repo inte dyker upp i gh repo list, försök istället med `gh repo view pafcloud/<namn>` direkt, eller be Tommy bekräfta repo-namnet.
