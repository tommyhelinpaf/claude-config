---
name: Feedback: always use remote git state for code questions
description: When answering code questions, always check origin/remote state — not just local
type: feedback
originSessionId: 30405ec2-74b1-4a59-bb9d-da7be8101457
---
When discussing code, branches, or recent changes in any repo, always check remote tracking state — not just local. Run `git fetch --all` first if needed, then use `git log origin/main`, `git diff origin/main..HEAD` etc. to answer from the latest known state.

**Why:** Local repo may not have been pulled recently; user wants answers based on what's actually on the remote, not stale local state.

**How to apply:** For any question involving "what's on main", "latest changes", "what did X commit", or similar — check remote refs, not just local.
