---
name: Reference: MCP servers & tooling
description: GitHub MCP and Qdrant setup — requires session restart to load
type: reference
---

**GitHub MCP:** Set up in a previous session so gh CLI / GitHub API tools are available. NOT loaded in fresh sessions automatically — requires Claude Code restart or re-initialization for MCP servers to load. Without it, gh commands fail silently (command not found).

**Qdrant:** Runs locally at 127.0.0.1:6333. Collection: claude-memory. MCP-based tools (qdrant-find, qdrant-store). Same issue — not loaded in all sessions. When available, query at session start for repo/service name.

**How to check if MCPs are loaded:** Try ToolSearch for "qdrant-find" or "gh". If not found, session needs restart.

**Workaround without gh:** Ask Tommy to run `! gh ...` commands in the prompt — output lands in conversation.
