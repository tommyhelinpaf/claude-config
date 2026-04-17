#!/bin/bash
# Syncs integrations-ai repo, updates Qdrant MCP deps, and ensures Qdrant + collection are ready

REPO=~/repos/integrations-ai
VENV=~/qdrant-mcp-venv

# Ensure Qdrant Docker container is running
if ! curl -s http://127.0.0.1:6333/healthz > /dev/null 2>&1; then
    docker start qdrant > /dev/null 2>&1
    sleep 2
fi

# Ensure claude-memory collection exists
curl -s -X PUT http://127.0.0.1:6333/collections/claude-memory \
  -H 'Content-Type: application/json' \
  -d '{"vectors":{"size":384,"distance":"Cosine"}}' > /dev/null 2>&1 || true

# Pull latest from integrations-ai
cd "$REPO" && git pull --quiet --ff-only 2>/dev/null

# Update deps if venv exists
if [ -d "$VENV" ]; then
    "$VENV/bin/pip" install --quiet --upgrade \
        mcp-server-qdrant fastmcp qdrant-client 2>/dev/null
fi