---
name: Feedback: files to never commit
description: Files that must never be staged or committed in PAF repos
type: feedback
---

NEVER commit these files (or similar):
- `CLAUDE.md` — Claude Code context file, local only
- `.claude/` — Claude Code session/memory directory
- `.factorypath` — IDE generated file
- `settings.local.json` — local IDE settings
- Any file matching `*.local.*` or `*.local` config patterns

**Why:** These are local tooling files that don't belong in repo history. Tommy was clear this should never happen.
**How to apply:** Before ANY commit, check `git status` and verify staged files. If any of these appear, remove with `git rm --cached` and add to `.gitignore` first. Add to `.gitignore` in the repo when first seen.
