---
name: Tänk proaktivt på IAM och Secrets Manager
description: När IAM-policys eller Secrets Manager nämns, påminn proaktivt om vanliga fallgropar
type: feedback
originSessionId: dd6d207a-ec86-4967-b73f-904c34e99c49
---
När Tommy pratar om IAM-policys, Secrets Manager, ny tjänste-deploy, eller terragrunt.hcl — tänk proaktivt på:

1. Är IAM-policyn (`secretsmanager-secret-read-policy-app_<service>`) attachad till ECS task role?
2. Har secreten ett värde satt (inte bara skapad tom av Terraform)?
3. Finns det en ternary-konditional i `.deployment/terragrunt.hcl` som utesluter policyn i prod?

**Why:** pushgaming-bonus-service kraschade 2026-04-20 i >30 min pga att en ternary uteslöt IAM-policyn i prod. Felet "Config data resource does not exist" kan bero på IAM ELLER tom secret — Spring Cloud AWS ger samma felmeddelande för båda fallen.

**How to apply:** Så fort ny tjänst ska deployas till prod med secrets, eller vid "does not exist"-fel i Datadog — gå igenom checklistan ovan utan att bli tillfrågad.
