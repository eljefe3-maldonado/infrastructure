# Roadmap

## P1

1. Run AWS-backed plans in a sandbox account for `bootstrap`, `log-archive`, `security`, and `dev`.
2. Add `org_id` and real delivery source account IDs to log archive inputs.
3. Enable CloudTrail delivery on the log archive bucket after org trail review.
4. Add constrained KMS conditions for log delivery service principals.
5. Create a first commit after review.

## P2

1. Build `environments/test` from the dev pattern.
2. Build `environments/prod` from the dev pattern with stricter production defaults.
3. Implement `org/organizations`, `org/ous`, and `org/account-baseline`.
4. Implement IAM Identity Center and permission sets.
5. Add CloudWatch log group module and alerting for break-glass role usage.

## P3

1. Implement VPC endpoints for S3, ECR, CloudWatch Logs, SSM, STS, KMS, and Secrets Manager.
2. Implement DNS baseline.
3. Implement workload baselines for EC2, RDS, and Lambda.
4. Add stronger OPA policies for IMDSv2, encryption, public exposure, and required tags.

## P4

1. Implement Inspector.
2. Implement Macie.
3. Implement EKS baseline.
4. Add AI/ML service baselines for SageMaker, Bedrock usage guardrails, and data perimeter controls.
