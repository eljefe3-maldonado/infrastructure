# Required AWS Permissions

Bootstrap requires permissions to manage S3, DynamoDB, KMS, and IAM policy documents in the target account.

Organization and security-service modules will require AWS Organizations administrator permissions and delegated administrator setup for services such as GuardDuty, Security Hub, Inspector, Macie, Config, and Access Analyzer.

## Bootstrap

`bootstrap/remote-state` needs permissions for:

- `s3:*` on the target state bucket.
- `dynamodb:*` on the lock table.
- `kms:*` for the state KMS key.
- `iam:GetPolicyDocument` is not an AWS API call, but the caller must be allowed to create policies that reference the current account.

Use a controlled administrator role for the initial bootstrap. After bootstrap, reduce day-to-day access to state read/write and lock table permissions.

## Log Archive

`environments/log-archive` needs permissions for:

- S3 bucket creation and bucket policy management.
- KMS key and alias management.
- Lifecycle, versioning, encryption, public access block, and ownership controls.

When enabling delivery from CloudTrail, Config, or VPC Flow Logs, confirm service delivery permissions are constrained by reviewed account IDs and organization ID where possible.

## Security Environment

`environments/security` may require:

- `cloudtrail:*`
- `guardduty:*`
- `securityhub:*`
- `access-analyzer:*`
- delegated administrator setup through AWS Organizations where used
- IAM permissions if CloudWatch Logs delivery roles are added later

Some organization-level operations must be run from the management account. Others should be run from delegated administrator accounts after delegation is configured.

## Organization SCPs

`org/scps` requires:

- `organizations:CreatePolicy`
- `organizations:UpdatePolicy`
- `organizations:DeletePolicy`
- `organizations:AttachPolicy`
- `organizations:DetachPolicy`
- `organizations:ListPolicies`
- `organizations:ListTargetsForPolicy`

Use a management-account role and test SCP attachments in a sandbox OU first.

## Break-Glass

`identity/break-glass` requires IAM role creation and policy attachment permissions:

- `iam:CreateRole`
- `iam:UpdateAssumeRolePolicy`
- `iam:AttachRolePolicy`
- `iam:TagRole`
- `iam:PassRole` only if another service needs to use the role, which this module does not require by default.

The break-glass role intentionally attaches `AdministratorAccess`. Restrict the trust policy to reviewed principals and keep MFA required.
