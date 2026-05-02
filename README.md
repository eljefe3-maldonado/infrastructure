# AWS Secure Baseline

This repository contains a modular Terraform baseline for secure AWS account foundations. It is organized for future platform engineering, cloud security engineering, and multi-account AWS environments.

## Current Scope

The current baseline includes secure remote state, centralized logging foundations, organization security services, SCP examples, break-glass IAM, VPC foundations, VPC Flow Logs, and a secure S3 workload baseline. It is still intentionally account-agnostic: real account IDs, backend values, IAM role ARNs, and organization IDs must be supplied outside source control.

## Repository Layout

```text
bootstrap/remote-state     Terraform state bucket, lock table, and KMS key
docs/                       Architecture, deployment, permissions, and roadmap
environments/               dev, test, prod, security, and log-archive roots
identity/                   Break-glass and IAM Identity Center modules
logging/                    KMS, log archive buckets, and CloudWatch logs
network/                    VPC, flow logs, endpoints, and DNS modules
org/                        AWS Organizations, OUs, SCPs, and account baseline
policies/                   Checkov, tfsec, OPA, and GitHub Actions policy config
security/                   CloudTrail, Config, GuardDuty, Security Hub, and related services
workload-baselines/         Reusable EC2, S3, RDS, Lambda, and EKS baselines
```

## Deployment Order

1. Run `bootstrap/remote-state` locally or from a controlled admin workstation.
2. Configure each environment backend using the created S3 bucket, DynamoDB table, KMS key, and workspace-specific key path.
3. Deploy `environments/log-archive` for centralized log storage and encryption.
4. Enable delivery permissions on the log archive bucket for CloudTrail, Config, and VPC Flow Logs as those services are deployed.
5. Deploy `environments/security` for organization CloudTrail, GuardDuty, Security Hub, and Access Analyzer.
6. Deploy `environments/dev` for VPC and VPC Flow Logs.
7. Add test and production environment roots once the dev pattern is reviewed.

Do not run `terraform apply` until AWS account IDs, organization structure, provider roles, and backend configuration are reviewed.

## Validation

```bash
terraform fmt -recursive
terraform -chdir=bootstrap/remote-state init -backend=false
terraform -chdir=bootstrap/remote-state validate
terraform -chdir=environments/log-archive init -backend=false
terraform -chdir=environments/log-archive validate
terraform -chdir=environments/security init -backend=false
terraform -chdir=environments/security validate
terraform -chdir=environments/dev init -backend=false
terraform -chdir=environments/dev validate
```

GitHub Actions runs format, init, validate, plan, Checkov, tfsec, and optional OPA checks without auto-apply.

## Security Defaults

- S3 state bucket encryption with a customer-managed KMS key.
- S3 bucket versioning and public access block.
- DynamoDB state locking with point-in-time recovery.
- Least-privilege module inputs with no hardcoded account IDs, ARNs, or bucket names.
- Required tagging support through module inputs.
- CloudTrail organization trail defaults to multi-region, global-service events, KMS encryption, and log file validation.
- GuardDuty, Security Hub, and Access Analyzer modules support organization-level operation.
- SCP module includes guardrails for root use, organization exit, S3 public access, unapproved regions, IMDSv2, and CloudTrail tampering.
- Break-glass role requires explicit trusted principals and MFA by default.

## Known Limitations

- Inspector, Macie, IAM Identity Center, permission sets, account factory, endpoints, RDS, EC2, Lambda, and EKS baselines are not implemented yet.
- `test` and `prod` are documented placeholders.
- Environment folders contain examples and backend templates, not live account wiring.
- Real AWS account IDs, IAM roles, backend bucket names, and regions must be supplied outside the repo.
- SCPs should be tested in a sandbox OU before broad attachment.
# infrastructure
