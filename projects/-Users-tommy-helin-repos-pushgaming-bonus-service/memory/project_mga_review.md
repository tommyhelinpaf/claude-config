---
name: Project: mga-bonus-service code review
description: Key findings from PR #8 code review — new MGA provider integration
type: project
---

Reviewed PR #8 — new MGA free rounds provider integration.

**requestId / idempotency — CORRECT:**
buildRequestId() uses UUID.nameUUIDFromBytes() — deterministic type-3 UUID. Same program content → same UUID. Idempotency works per MGA docs 4.4.2.

**assignmentReference inconsistency — REAL BUG:**
- addPlayerToProgram returns: "mga-" + triggerId (e.g. "mga-abc123")
- isPlayerInProgram (recovery path) returns: extBonusProgramId = playerStepId (e.g. "12345")
- pafis-bonus-service stores this in DB and uses it as lookup key (findByPlayerIdAndReference)
- pafis-wallet uses assignmentReference as fallback when playerStepId not provided (RoService.java:77)
- Impact depends on MGA translator implementation — if translator sends playerStepId, wallet uses that directly and reference doesn't matter for wallet. But getBonusProgramByReference lookups would be broken.
- Fix: isPlayerInProgram should return consistent reference format. But PendingTriggerResponse has no triggerId field — MGA's getPendingTriggers doesn't return it. So either fix addPlayerToProgram to use extBonusProgramId, or accept inconsistency and document it.

**Other findings:**
- deriveGameCategory() uses startsWith heuristic on launcherId — fragile, silent fallback to SLOTS3
- buildRequestId() string concat without separators — low collision risk but exists
- TRIGGER_DUPLICATE returns null assignmentReference — known limitation, MGA has no way to retrieve original triggerId
- getBetLevels() uses templates as workaround (no dedicated endpoint) — well documented
- removePlayerFromProgram() always throws — MGA has no forfeit endpoint — correct behavior
