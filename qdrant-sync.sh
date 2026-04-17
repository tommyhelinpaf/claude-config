#!/bin/bash
# Syncs integrations-ai repo and updates Qdrant MCP deps silently in the background

REPO=~/repos/integrations-ai
VENV=~/qdrant-mcp-venv

# Pull latest from integrations-ai
cd "$REPO" && git pull --quiet --ff-only 2>/dev/null

# Update deps if venv exists
if [ -d "$VENV" ]; then
    "$VENV/bin/pip" install --quiet --upgrade \
        mcp-server-qdrant fastmcp qdrant-client 2>/dev/null
fi
