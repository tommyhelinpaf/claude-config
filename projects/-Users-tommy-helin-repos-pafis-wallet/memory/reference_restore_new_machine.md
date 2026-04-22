---
name: Återställ Claude-setup på ny dator
description: Steg-för-steg för att återställa Claude-konfiguration, minnen och projektsettings på en ny maskin
type: reference
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
Backup-repo: https://github.com/tommyhelinpaf/claude-config

## Vad som backas upp
- `~/.claude/CLAUDE.md`, `settings.json`, `.gitignore`
- `~/.claude/projects/*/memory/` — alla konversationsminnen
- `~/.claude/qdrant-backup.json` — Qdrant-minnesdump
- `~/.claude/project-settings/pafis-wallet/settings.local.json` — projektspecifika permissions

## Återställ på ny dator
1. Klona backup-repot: `git clone git@github.com:tommyhelinpaf/claude-config.git ~/.claude`
2. Kopiera projektsettings tillbaka: `cp ~/.claude/project-settings/pafis-wallet/settings.local.json ~/repos/pafis-wallet/.claude/settings.local.json`
3. Starta Qdrant lokalt och importera backup (`qdrant-backup.json`) om vektorminnen ska återställas

## Vad Tommy ska säga i ny session
"Jag har fått ny dator. Mitt backup-repo är https://github.com/tommyhelinpaf/claude-config — kan du hjälpa mig återställa min Claude-setup?"
