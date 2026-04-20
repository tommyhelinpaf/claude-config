---
name: Qdrant backup — cronjobb 15:00 varje vardag
description: Automatisk backup av Qdrant-minnen + CLAUDE.md till privat git-repo via cron
type: reference
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Cronjobb kör `~/.claude/claude-backup.sh` kl 15:00 måndag–fredag.

Scriptet:
1. Kör `~/.claude/qdrant-backup.sh` — exporterar alla punkter från collection `claude-memory` till `~/.claude/qdrant-backup.json` via Qdrant scroll-API
2. Git add: CLAUDE.md, settings.json, qdrant-sync.sh, qdrant-backup.sh, qdrant-backup.json, .gitignore, projects/*/memory/
3. Commit + push till `origin HEAD:main`

Backup-repo: https://github.com/tommyhelinpaf/claude-config
