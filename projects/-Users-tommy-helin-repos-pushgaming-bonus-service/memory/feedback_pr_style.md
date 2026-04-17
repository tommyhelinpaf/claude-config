---
name: Feedback: PR writing style per service type
description: How Tommy writes PR descriptions — built from real PR history across repos
type: feedback
---

## Bonus services (*-bonus-service)
Short and direct. One paragraph, max 2. No headers/sections. Explains what changed and why in plain language. Casual tone.

Examples:
- "Adding config for com to be able to assign freespins in provider system"
- "Adding support for PushGaming's games for all our Spanish sites"
- "Using java.util.Currency instead of String when binding to application config, and also throughout layers. Also adhering to test convention i.e. using arrange-act-assert"

**How to apply:** One short paragraph. No markdown headers. Explain the "what" and "why" in plain language. If it's a config change, say what it enables.

## Translator services (pafis-tx-*)
Similar to bonus — casual prose. Can be slightly longer if explaining a new flow or non-obvious reasoning. Mentions provider name and what it enables. May reference technical details if relevant.

Examples:
- "We're implementing Pushgaming Freespins (fs). And we do it by implementing it in a new way, where wallet service finds out how many units to consume and what total bet amount it is since provider don't send it to us."
- "Adding jurisdiction and currency params. Currency param will give correct currency and bet levels for non-euro games supporting it..."

**How to apply:** Prose, 1-3 sentences. Explain what flow is being added/changed and why. Name the provider. Mention constraints or edge cases if relevant.

## pafis-wallet (most important service — more structured)
Uses markdown section headers. More formal. Covers description, changes, impact, test scenarios.

Template:
```
### Description:
[what and why]

### Changes:
- [bullet points]

### Impact & Considerations:
[risk/scope notes]

### Scenarios to test in CI:
- [test cases]
```

**How to apply:** Always use the structured template for pafis-wallet PRs. Be thorough about impact and test scenarios.

## pafis-bonus-service
Similar structure to pafis-wallet when changes are significant. Shorter for minor fixes.
