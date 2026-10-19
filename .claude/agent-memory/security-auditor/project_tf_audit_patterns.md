---
name: project-tf-audit-patterns
description: Recurring gaps in this repo's Terraform/CI (OIDC missing from TF, workflow/TF drift, missing headers policy)
metadata:
  type: project
---

Audit 2026-10-16 and re-audit 2026-10-17: terraform/ has S3+CloudFront(OAC) only (main.tf, providers.tf, variables.tf, outputs.tf, backend.tf). NO aws_iam_openid_connect_provider/role in TF (role created manually). deploy.yml hardcodes a different account (533267262133), bucket (pravinmishradmi-site-production), region (eu-north-1) and distribution (E3V6O6MRE2E21P) than TF (agulaldi-portfolio1-<acct>, us-east-1). Fixed since first audit: TF no longer hardcodes account ID (uses aws_caller_identity). Still open: no response headers policy, no TLS-only deny in bucket policy, no logging/versioning/KMS, default CF cert (TLS min not enforceable), no WAF, backend block commented out, provider ~> 5.0 (no lock file check), workflow actions pinned to tags (@v4) not SHAs, no job-level permissions/environment, `--delete` on sync, no CI trigger for terraform.

**How to apply:** On re-audit, check whether these were fixed; verify before reporting.
