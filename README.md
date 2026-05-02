# AWS Secure Baseline

A modular Terraform baseline for secure AWS account foundations, organized for platform engineering, cloud security engineering, and multi-account AWS environments.

## Implementation Status

| Area | Status |
|---|---|
| Remote state (S3, DynamoDB, KMS) | Implemented |
| Centralized log archive bucket + KMS | Implemented |
| Organization CloudTrail | Implemented |
| AWS Config recorder + delivery channel | Implemented |
| GuardDuty (org-level) | Implemented |
| Security Hub (CIS + FSBP standards) | Implemented |
| IAM Access Analyzer | Implemented |
| Break-glass IAM role | Implemented |
| Service Control Policies (6 guardrails) | Implemented |
| VPC baseline | Implemented |
| VPC Flow Logs | Implemented |
| Secure S3 workload baseline | Implemented |
| IAM Identity Center, permission sets | Scaffolded — not yet implemented |
| CloudWatch log groups | Scaffolded — not yet implemented |
| VPC endpoints, DNS | Scaffolded — not yet implemented |
| Organizations, OUs, account baseline | Scaffolded — not yet implemented |
| Inspector, Macie | Scaffolded — not yet implemented |
| EC2, RDS, Lambda, EKS baselines | Scaffolded — not yet implemented |
| `environments/test`, `environments/prod` | Scaffolded — not yet implemented |

## Repository Layout

```text
bootstrap/
  remote-state/             S3 state bucket, DynamoDB lock table, KMS key

environments/
  log-archive/              Centralized log bucket + KMS key (deploy second)
  security/                 CloudTrail, GuardDuty, Security Hub, Access Analyzer
  dev/                      VPC + VPC Flow Logs targeting central log archive
  test/                     Placeholder — mirrors dev pattern
  prod/                     Placeholder — mirrors dev pattern, stricter inputs

identity/
  break-glass/              Emergency IAM role with MFA enforcement
  permission-sets/          Placeholder — IAM Identity Center permission sets

logging/
  kms-keys/                 Reusable KMS key module with policy and service grants
  log-archive-buckets/      S3 log archive with lifecycle, cross-account, org policy
  cloudwatch-log-groups/    Placeholder

network/
  vpc-baseline/             VPC, subnets, IGW, NAT gateway, locked default SG
  vpc-flow-logs/            VPC Flow Logs to S3 or CloudWatch Logs
  endpoints/                Placeholder — PrivateLink VPC endpoints
  dns/                      Placeholder — Route 53 private hosted zones

org/
  scps/                     Six SCPs: root deny, leave-org, public S3, regions, IMDSv2, CloudTrail
  organizations/            Placeholder
  ous/                      Placeholder
  account-baseline/         Placeholder

policies/
  checkov/                  Checkov config (MEDIUM+ severity, skip-check list)
  tfsec/                    tfsec config (MEDIUM+ severity)
  opa/                      Conftest policies: public S3 deny, required tags
  github-actions/           Placeholder

security/
  cloudtrail-org/           Organization multi-region trail with KMS + log validation
  config-org/               Config recorder, delivery channel, IAM role
  guardduty-org/            GuardDuty detector + org admin delegation
  security-hub-org/         Security Hub + CIS/FSBP standards + org admin
  access-analyzer/          IAM Access Analyzer (ACCOUNT or ORGANIZATION)
  inspector/                Placeholder
  macie/                    Placeholder

workload-baselines/
  s3/                       Secure general-purpose S3 bucket (KMS, versioning, lifecycle)
  ec2/                      Placeholder
  rds/                      Placeholder
  lambda/                   Placeholder
  eks/                      Placeholder

docs/                       Architecture, deployment order, permissions, roadmap
```

## Deployment Order

Deploy in this sequence. Each step depends on outputs from the previous.

```
1. bootstrap/remote-state       # Creates S3 bucket, DynamoDB table, KMS key
2. environments/log-archive     # Creates central log bucket + KMS key
3. environments/security        # CloudTrail, GuardDuty, Security Hub, Access Analyzer
4. environments/dev             # VPC + VPC Flow Logs → central log bucket
5. environments/test            # (when ready — copy dev pattern)
6. environments/prod            # (when ready — copy dev pattern, tighten inputs)
```

Do not run `terraform apply` until account IDs, organization structure, provider roles, and backend configuration have been reviewed. See `docs/deployment-order.md` for full details.

## Backend Initialization

Each environment uses a separate S3 backend key. Initialize with:

```bash
terraform -chdir=<environment> init -backend-config=backend.hcl
```

Each environment directory contains a `backend.hcl.example`. Copy it to `backend.hcl` (not committed), fill in the values from `bootstrap/remote-state` outputs, and run `init`.

## Validation

```bash
# Format check — runs across all modules
terraform fmt -check -recursive

# Per-root init and validate (no backend required)
terraform -chdir=bootstrap/remote-state init -backend=false && terraform -chdir=bootstrap/remote-state validate
terraform -chdir=environments/log-archive init -backend=false && terraform -chdir=environments/log-archive validate
terraform -chdir=environments/security init -backend=false && terraform -chdir=environments/security validate
terraform -chdir=environments/dev init -backend=false && terraform -chdir=environments/dev validate
```

CI runs the same checks automatically on every PR and push to `main`. See `.github/workflows/terraform-validate.yml`.

## Security Defaults

Every module enforces these by default. Overrides require explicit variable changes.

- KMS customer-managed keys with automatic rotation and least-privilege key policies
- S3 public access block enabled on all buckets (all four settings)
- S3 bucket-owner-enforced ownership (ACLs disabled)
- HTTPS-only S3 bucket policies (`aws:SecureTransport` deny)
- DynamoDB state lock table with point-in-time recovery and KMS encryption
- CloudTrail multi-region, log file validation, global service events, KMS encryption
- GuardDuty with S3, Kubernetes audit logs, and EBS malware protection
- Security Hub with CIS AWS Foundations and AWS Foundational Security Best Practices
- VPC default security group locked down (no ingress or egress rules)
- No auto-assign public IP on launch in any subnet
- Break-glass role requires MFA with a 1-hour maximum age
- SCPs enforce: no root actions, no org exit, no S3 public access removal, IMDSv2 required, no CloudTrail tampering
- No hardcoded account IDs, ARNs, regions, or bucket names anywhere in source

## Known Limitations

- `environments/test` and `environments/prod` are directory placeholders with READMEs only.
- Inspector, Macie, IAM Identity Center, permission sets, and account baseline modules are empty scaffolds.
- VPC endpoints and DNS modules are not yet implemented (relevant for private workload connectivity).
- `org/organizations`, `org/ous`, and `org/account-baseline` are empty scaffolds.
- EC2, RDS, Lambda, and EKS workload baselines are empty scaffolds.
- Real account IDs, IAM role ARNs, backend bucket names, and org IDs must be supplied outside the repo.
- SCPs must be tested in a sandbox OU before attaching to production OUs.
- The `security/` environment requires management account or delegated admin credentials for org-level resources (CloudTrail org trail, GuardDuty org admin, Security Hub org admin).
