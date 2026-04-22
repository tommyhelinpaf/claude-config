# Restore Claude setup on new machine

## What this repo contains
- `CLAUDE.md` — global Claude instructions
- `settings.json` — global Claude settings
- `projects/*/memory/` — persistent memory across all projects
- `qdrant-backup.json` — Qdrant vector memory dump
- `project-settings/pafis-wallet/settings.local.json` — project-specific permissions
- `claude-backup.sh`, `qdrant-backup.sh` — backup scripts (run via cron at 15:00 weekdays)

## Restore steps

### 1. Install Claude Code
Download and install from https://claude.ai/download

### 2. Clone this repo
```bash
git clone https://github.com/tommyhelinpaf/claude-config.git ~/.claude
```

### 3. Restore project settings
```bash
mkdir -p ~/repos/pafis-wallet/.claude
cp ~/.claude/project-settings/pafis-wallet/settings.local.json ~/repos/pafis-wallet/.claude/settings.local.json
```

### 4. Set up cron backup (so backups continue automatically)
```bash
crontab -e
```
Add this line:
```
0 15 * * 1-5 bash ~/.claude/claude-backup.sh >> ~/.claude/backup-cron.log 2>&1
```

### 5. (Optional) Restore Qdrant vector memory
Start Qdrant locally, then import `qdrant-backup.json` via the Qdrant API.

### 6. Start Claude Code
Open a new session — memories will be loaded automatically from `projects/*/memory/`.

## In a new Claude session, say:
> "Jag har fått ny dator. Jag har klonat https://github.com/tommyhelinpaf/claude-config till ~/.claude. Kan du hjälpa mig verifiera att allt är återställt?"
