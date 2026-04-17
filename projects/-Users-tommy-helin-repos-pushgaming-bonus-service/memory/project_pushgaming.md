---
name: Project: pushgaming-bonus-service
description: What was done on branch IG-9355-adding-config-com, key patterns and gotchas
type: project
---

Branch: IG-9355-adding-config-com

**What was fixed (2026-04-16/17):**
- Compilation errors in 3 test files: SiteConfig record has 2 fields (igpCode, currency) — tests were passing 3 args
- meshApiKey is a separate field on ApplicationConfig, not part of SiteConfig — must be mocked separately in tests
- SonarCloud issues: removed @NonNull parameter violation (Optional.orElse(null)), removed redundant null check on @NonNull List field
- Uncommented BonusResourceTest, updated to use @MockitoBean/@MockitoSpyBean (not deprecated @MockBean)
- Removed unused import in PushgamingErrorDecoder

**Prod config (application-prod.yml):**
- host: https://mesh.eu.regulated2.pushgaming.com
- context: /mesh/b2b/igp
- mesh-api-key NOT in yml — comes from AWS Secrets Manager
- Same igp-codes and currencies as CI

**Key patterns:**
- SiteConfig record: (igpCode, currency) — 2 fields only
- meshApiKey: top-level field on ApplicationConfig, per-site in prod via Secrets Manager
- ApplicationConfig.sites() returns Map<String, SiteConfig>
