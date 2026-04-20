---
name: PR signing — använd alltid lokal git med git commit -S
description: PAF-repos kräver GPG-signerade commits. Använd alltid lokal git-workflow, aldrig GitHub API, när du skapar commits i PRs.
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
För repos som kräver signerade commits (PAF standard): använd alltid lokal git-workflow.

**Workflow:**
1. Kolla om repot finns klonat lokalt (`ls ~/repos/` eller `~/Github/`)
2. Gör ändringar direkt på lokala filer med Edit/Write-verktygen
3. `git add <file>`
4. `git commit -S -m "..."` — GPG-agenten hanterar signering automatiskt, utan lösenfraspopup
5. `git push origin <branch>`
6. `gh pr create`

**Why:** GitHub API (PUT /contents) skapar osignerade commits → "Merging is blocked: Commits must have verified signatures". Lokal `git commit -S` triggar GPG-agenten som har cachat nyckeln — ingen popup behövs.

**How to apply:** Alltid när jag skapar en PR i ett PAF-repo. Aldrig använda GitHub API för att skapa commits.
