#!/bin/bash
# Exports all Qdrant claude-memory points to JSON for git backup

BACKUP_FILE=~/.claude/qdrant-backup.json
COLLECTION="claude-memory"
BASE_URL="http://127.0.0.1:6333"
LIMIT=100

# Check Qdrant is running
if ! curl -s "$BASE_URL/healthz" > /dev/null 2>&1; then
    exit 0
fi

# Scroll all points with payload and vectors
ALL_POINTS="[]"
OFFSET=""

while true; do
    BODY="{\"limit\": $LIMIT, \"with_payload\": true, \"with_vectors\": true}"
    if [ -n "$OFFSET" ]; then
        BODY="{\"limit\": $LIMIT, \"with_payload\": true, \"with_vectors\": true, \"offset\": \"$OFFSET\"}"
    fi

    RESPONSE=$(curl -s -X POST "$BASE_URL/collections/$COLLECTION/points/scroll" \
        -H 'Content-Type: application/json' \
        -d "$BODY")

    POINTS=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps(d['result']['points']))" 2>/dev/null)
    NEXT=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result'].get('next_page_offset') or '')" 2>/dev/null)

    ALL_POINTS=$(python3 -c "import json,sys; a=json.loads('$ALL_POINTS'); b=json.loads(sys.argv[1]); print(json.dumps(a+b))" "$POINTS" 2>/dev/null || echo "$ALL_POINTS")

    if [ -z "$NEXT" ] || [ "$NEXT" = "None" ]; then
        break
    fi
    OFFSET="$NEXT"
done

echo "$ALL_POINTS" > "$BACKUP_FILE"