---
name: Skapa aldrig filer som hamnar som unversioned i git
description: Claude ska aldrig skapa filer i repos som blir unversioned/untracked, utom genuint temporära filer
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Skapa aldrig tooling/settings-filer i ett repo som hamnar som untracked/unversioned i git utan att de är gitignore:ade.

**Why:** .factorypath och .claude/settings.local.json dök upp som unversioned i pafis-wallet. Tommy vill inte ha skräp i `git status`.

**How to apply:** Gäller ENBART IDE/tooling-filer och personliga settings som aldrig ska committas till teamets repo (t.ex. `.factorypath`, `.claude/settings.local.json`). Kodfiler (Java-klasser, konfigurationsfiler, tester, etc.) ska alltid vara trackade och committas normalt — gitignore:a aldrig kodfiler.

För tooling-filer: lägg till i `~/.gitignore_global` (global, påverkar alla repos) eller be Tommy lägga till i `.gitignore` i repot. Alternativt: skapa filen utanför repot (t.ex. i `~/.claude/`).

Globala gitignore: `~/.gitignore_global`. Redan ignorerade: `.factorypath`, `.claude/settings.local.json`, `.claude/settings.json`.
