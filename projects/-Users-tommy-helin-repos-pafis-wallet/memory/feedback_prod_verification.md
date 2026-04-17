---
name: Prod Deployment Verification
description: How to correctly verify that a service version is actually running in prod (not just in code)
type: feedback
originSessionId: 077b6cff-38b8-4f9a-a1d1-4101d6790c5e
---
Never assume a version is in prod based on source code or pom.xml alone. Always verify the actual deployed version.

**Why:** During IG-10032 (consume-all), multiple services had correct code in source but deployment PRs in live-prod-apps were OPEN and NOT MERGED — meaning prod was on old versions. This would have caused silent failures.

**How to apply:**
- Source code / pom.xml = what *could* be deployed, not what *is* deployed
- To confirm actual prod version, use BOTH:
  1. **Datadog**: search logs for `service:<name> env:prod` with `extra_fields: ["version"]` to get the deployed version tag
  2. **live-prod-apps repo**: confirm the deployment PR for the required version is MERGED, not just open
- When asked "är alla services redo för prod?" or similar: always check Datadog for running versions, not just code
- Flag any service where deployment PR exists but is OPEN — that means NOT in prod yet
- Do NOT present a service as "ready" without confirming the version via Datadog or live-prod-apps merge status
