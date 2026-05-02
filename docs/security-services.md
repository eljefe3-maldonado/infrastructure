# Security Services

Current baseline coverage:

- Organization CloudTrail.
- AWS Config recorder and delivery channel module.
- GuardDuty detector and optional organization configuration.
- Security Hub account, organization configuration, and standards subscriptions.
- IAM Access Analyzer.
- Centralized log archive buckets.
- VPC Flow Logs.
- SCP examples.
- Break-glass IAM role.

Planned but not implemented yet:

- Inspector.
- Macie.
- IAM Identity Center.
- Permission sets.
- Organization account baseline.

## CloudTrail

Module: `security/cloudtrail-org`

Defaults used by `environments/security`:

- Organization trail enabled.
- Multi-region trail enabled.
- Global service events included.
- Log file validation enabled.
- KMS encryption required through `log_archive_kms_key_arn`.
- Delivery to centralized log archive bucket.

Before deploying, enable CloudTrail delivery permissions in `environments/log-archive`.

## GuardDuty

Module: `security/guardduty-org`

Supports:

- Detector creation.
- S3 log protection.
- Kubernetes audit log monitoring.
- Malware protection for EC2 findings.
- Optional delegated administrator account.
- Organization member auto-enable.

GuardDuty organization configuration should be tested in a sandbox or non-production OU first when possible.

## Security Hub

Module: `security/security-hub-org`

Supports:

- Explicit enable/disable through `enable`.
- Delegated administrator account.
- Organization member auto-enable.
- CIS AWS Foundations Benchmark.
- AWS Foundational Security Best Practices.
- Optional PCI DSS standard.

Default standards are disabled at account creation so standards are explicitly managed by Terraform.

## Access Analyzer

Module: `security/access-analyzer`

Supports:

- Account or organization analyzer type.
- Archive rules for reviewed findings.

Use archive rules sparingly. Every archive rule should have a documented reason.

## AWS Config

Module: `security/config-org`

Supports:

- Configuration recorder.
- Delivery channel.
- Optional IAM role creation.
- Recorder status enablement.

Config aggregation and organization-wide deployment are still future work.

## SCP Guardrails

Module: `org/scps`

Current SCP examples:

- Deny root account actions.
- Deny leaving the organization.
- Deny S3 Public Access Block weakening.
- Deny unapproved regions.
- Require EC2 IMDSv2.
- Deny CloudTrail disable or modification.

Apply SCPs to a sandbox OU first. SCP mistakes can block administrators and automation.

## Break-Glass

Module: `identity/break-glass`

The role uses `AdministratorAccess` intentionally. The security controls are in the trust policy and operations process:

- Trusted principals must be explicitly supplied.
- MFA is required by default.
- MFA age is capped.
- Session duration is validated.
- Usage must be monitored through CloudTrail and alerting.
