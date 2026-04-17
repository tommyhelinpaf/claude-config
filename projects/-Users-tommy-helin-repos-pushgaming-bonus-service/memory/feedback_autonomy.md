---
name: Feedback: autonomy & working style
description: How Tommy wants Claude to behave — minimize friction, match team style
type: feedback
---

Minimize approval prompts. Tommy dislikes needing to approve every step.
**Why:** Slows down the workflow significantly.
**How to apply:** Batch related edits, don't ask for confirmation on obviously safe operations (reading files, writing config, running tests). Ask only before risky/irreversible actions.

PR descriptions must look like Tommy wrote them — always read his last 10 PRs on the repo first before writing.
**Why:** AI-sounding PRs are unwanted.
**How to apply:** Use `gh pr list --author "@me" --limit 10` before drafting any PR.

mesh-api-key for pushgaming is NOT stored in yml config files — it comes from AWS Secrets Manager.
**Why:** Security. CI and prod yml files intentionally omit it.
**How to apply:** Never add mesh-api-key to application-*.yml files.

Auto-adapt process improvements without being asked. If something could be faster or smoother, just do it.

Tommy never wants to know exact commands or technical details — that's Claude's job.
**Why:** He wants to stay at the intent level, not implementation level.
**How to apply:** When asking Tommy to run something, just say "kör:" + the exact line to paste. No explanation of what it does. Never ask him to figure out syntax himself. If I need output from a command, give him one paste-ready line using the `! <command>` format.
