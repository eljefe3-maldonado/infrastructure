# Module Inventory

## Bootstrap

| Module | Status | Notes |
| --- | --- | --- |
| `bootstrap/remote-state` | Implemented | S3 state bucket, DynamoDB lock table, KMS key, versioning, encryption, public access block, and HTTPS-only policy. |

## Logging

| Module | Status | Notes |
| --- | --- | --- |
| `logging/kms-keys` | Implemented | KMS key with rotation, explicit account root administration, optional IAM/service principal usage, and optional grants. |
| `logging/log-archive-buckets` | Implemented | Versioned encrypted S3 bucket with lifecycle, public access block, HTTPS-only policy, optional service delivery, org guardrail, and cross-account write support. |
| `logging/cloudwatch-log-groups` | Placeholder | Future structured log group baseline. |

## Security

| Module | Status | Notes |
| --- | --- | --- |
| `security/cloudtrail-org` | Implemented | Organization-capable CloudTrail with KMS encryption and log validation. |
| `security/config-org` | Implemented | Config recorder and delivery channel. Aggregation is future work. |
| `security/guardduty-org` | Implemented | Detector, optional delegated admin, and org configuration. |
| `security/security-hub-org` | Implemented | Account enablement, delegated admin, org configuration, and standards. |
| `security/access-analyzer` | Implemented | Account or organization analyzer with archive rules. |
| `security/inspector` | Placeholder | Future implementation. |
| `security/macie` | Placeholder | Future implementation. |

## Identity

| Module | Status | Notes |
| --- | --- | --- |
| `identity/break-glass` | Implemented | MFA-gated administrator role for emergency access. |
| `identity/permission-sets` | Placeholder | Future IAM Identity Center permission sets. |

## Organization

| Module | Status | Notes |
| --- | --- | --- |
| `org/scps` | Implemented | Root, org exit, S3 public access, region, IMDSv2, and CloudTrail guardrails. |
| `org/organizations` | Placeholder | Future organization management. |
| `org/ous` | Placeholder | Future OU management. |
| `org/account-baseline` | Placeholder | Future account bootstrap controls. |

## Network

| Module | Status | Notes |
| --- | --- | --- |
| `network/vpc-baseline` | Implemented | VPC, subnets, route tables, optional NAT, IGW, and locked-down default security group. |
| `network/vpc-flow-logs` | Implemented | Flow logs to S3 or CloudWatch Logs, including Parquet/Hive options for S3. |
| `network/endpoints` | Placeholder | Future PrivateLink endpoints. |
| `network/dns` | Placeholder | Future Route 53 resolver and DNS baseline. |

## Workload Baselines

| Module | Status | Notes |
| --- | --- | --- |
| `workload-baselines/s3` | Implemented | Secure S3 bucket baseline with encryption, public access block, versioning, lifecycle, optional logging, CORS, and intelligent tiering. |
| `workload-baselines/ec2` | Placeholder | Future EC2 baseline. |
| `workload-baselines/rds` | Placeholder | Future RDS baseline. |
| `workload-baselines/lambda` | Placeholder | Future Lambda baseline. |
| `workload-baselines/eks` | Placeholder | Future EKS baseline. |
