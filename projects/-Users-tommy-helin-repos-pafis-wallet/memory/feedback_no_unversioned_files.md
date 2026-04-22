---
name: Skapa aldrig filer som hamnar som unversioned i git
description: Claude ska aldrig skapa filer i repos som blir unversioned/untracked, utom genuint temporära filer
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Skapa aldrig filer i ett repo som hamnar som untracked/unversioned i git, om de inte är genuint temporära (och tas bort direkt efteråt).

**Why:** .factorypath och .claude/settings.local.json dök upp som unversioned i pafis-wallet. Tommy vill inte ha skräp i `git status`.

**How to apply:** Innan du skapar en fil i ett repo — kontrollera om den kommer att synas i `git status`. Om ja: antingen lägg till den i `.gitignore` (globalt eller lokalt) INNAN du skapar den, eller skapa den utanför repot (t.ex. i `~/.claude/`).

Globala gitignore-regler finns i `~/.gitignore_global` (konfigurerad via `git config --global core.excludesfile`). Redan ignorerade: `.factorypath`, `.claude/settings.local.json`, `.claude/settings.json`.
