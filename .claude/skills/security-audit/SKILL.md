---
name: security-audit
description: Read-only security review of the Terraform code in terraform/ (S3 public access, CloudFront OAC and HTTPS, IAM scope, hardcoded secrets, tags). Use before /tf-plan or /tf-apply, or whenever the user asks for a security review of the infrastructure.
allowed-tools: Read, Grep, Glob, Bash(terraform validate:*), Bash(terraform fmt -check:*)
disable-model-invocation: true
---

Audit the Terraform code in `terraform/` for security issues. This skill is read-only: never edit files, never run `terraform plan`, `apply` or `destroy`, and never call AWS.

Steps:
- [ ] If `terraform/` does not exist, stop and tell the user to run `/scaffold-terraform` first.
- [ ] Run `terraform fmt -check` and `terraform validate` in `terraform/` and report any errors.
- [ ] Check the S3 bucket: all four public access block settings are `true`, no public ACL or `Principal: "*"` policy, and the bucket policy only allows the CloudFront distribution (OAC, not legacy OAI) to read.
- [ ] Check CloudFront: `viewer_protocol_policy = "redirect-to-https"`, a modern minimum TLS version, and the origin uses OAC.
- [ ] Search for hardcoded secrets (access keys, `AKIA…`, passwords, account IDs in resource ARNs) and IAM policies with `"*"` actions or resources; confirm every resource has `Project` and `Environment` tags.

Report the findings as a table: severity (High / Medium / Low), file:line, issue, suggested fix. End with a one-line verdict: "Safe to plan" or "Fix before plan".
