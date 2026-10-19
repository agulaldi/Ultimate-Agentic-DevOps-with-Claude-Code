---
name: tf-apply
description: Run terraform apply to create or update AWS infrastructure. Use after reviewing a terraform plan.
allowed-tools: Bash, Read
disable-model-invocation: true
---

Apply a saved plan instead of `-auto-approve`, so only the reviewed plan is applied (the PreToolUse hook blocks `terraform apply -auto-approve`). Run all commands from the project root.

1. Run `cd terraform && terraform plan -out=apply.tfplan -no-color` and summarize how many resources will be added, changed and destroyed. If anything will be destroyed or replaced, stop and ask before applying.
2. Run `cd terraform && terraform apply -no-color apply.tfplan`.
3. Run `rm terraform/apply.tfplan` (a saved plan can contain sensitive values).

After apply completes:
- [ ] Show the key outputs (CloudFront URL, S3 bucket name, distribution ID)
- [ ] Verify the deployment by checking if the CloudFront distribution status is "Deployed"
- [ ] Report any errors and suggest fixes

If apply fails, do NOT retry automatically. Show the error and wait for instructions.
