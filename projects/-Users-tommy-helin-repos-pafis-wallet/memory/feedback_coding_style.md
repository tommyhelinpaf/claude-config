---
name: Coding Style Feedback
description: Corrections and preferences learned during consume-all implementation
type: feedback
---

- Don't wrap single log statements in a method - just inline them.
**Why:** Over-abstraction for one-liners. The log message is already self-documenting.
**How to apply:** Only extract logging to methods if there's actual logic (branching, formatting).

- Use playerStepId for bindingRef and eventId in freespin summary requests, not provider transaction IDs.
**Why:** playerStepId is unique per bonus reward and stable across provider retries. Provider rgsTxnId can change between retries breaking idempotency.
**How to apply:** For any freespin/bonus summary flow, use the PBS reward identifier as the linking key.

- Challenge assumptions - Tommy prefers being asked "is this really needed?" over silently implementing something questionable.
**Why:** Caught issues like redundant timestamp columns, unnecessary fabrication after getSessionByTimestamp, too-broad exception catching.
**How to apply:** When something seems off, ask before implementing.

- Rename things that have repetitive or unclear names (e.g. processReprocessRequest → retryConsumeAllWithdraw).
**Why:** Code readability matters. Names should describe what the method does, not mirror the class name.
**How to apply:** After writing code, review method names for clarity.

- Always check parent/base classes before answering questions about field defaults, annotations, or behavior.
**Why:** Answered incorrectly that `businessEventData` would be null without explicit initialization, when the base class `PAFISWalletRequest` had `@Builder.Default` setting it to `new HashMap<>()`.
**How to apply:** Before making claims about field behavior (nullability, defaults, validation), read the full class hierarchy — not just the class in question.
