# Secure S3 Workload Baseline

General-purpose S3 bucket module with opinionated secure defaults: public access blocked, bucket-owner-enforced ownership, HTTPS-only policy, optional KMS encryption, optional versioning, lifecycle, intelligent-tiering, CORS, and server access logging.

## Description

This module provisions an S3 bucket with all major security controls enabled by default. It is suitable as a baseline for any workload bucket — application data, log archives, artifact storage — where security posture matters. Optional features (lifecycle, intelligent-tiering, CORS, logging) are toggled via boolean or list variables.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| bucket_name | string | required | Globally unique S3 bucket name |
| kms_key_arn | string | "" | KMS key ARN for SSE-KMS. Empty = SSE-S3 (AES256) |
| enable_versioning | bool | true | Enable S3 versioning |
| force_destroy | bool | false | Allow destroying non-empty bucket |
| enable_lifecycle | bool | false | Enable lifecycle rules |
| noncurrent_version_expiration_days | number | 90 | Days before noncurrent versions are deleted |
| intelligent_tiering | bool | false | Enable Intelligent-Tiering |
| cors_rules | list(object) | [] | CORS rules for browser-based access |
| allowed_account_ids | list(string) | [] | Additional AWS account IDs for cross-account access |
| bucket_policy_statements | list(any) | [] | Additional bucket policy statements |
| enable_server_access_logging | bool | false | Enable S3 server access logging |
| access_log_bucket | string | "" | Target bucket for server access logs |
| access_log_prefix | string | "" | Prefix for server access logs |
| tags | map(string) | {} | Tags applied to bucket resources |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | S3 bucket ID (name) |
| bucket_arn | S3 bucket ARN |
| bucket_regional_domain_name | S3 bucket regional domain name |

## Example Usage

```hcl
module "app_data_bucket" {
  source = "../../workload-baselines/s3"

  bucket_name = "my-org-app-data-us-east-1"
  kms_key_arn = "arn:aws:kms:us-east-1:111122223333:key/mrk-abc123"

  enable_versioning = true
  enable_lifecycle  = true
  noncurrent_version_expiration_days = 90

  enable_server_access_logging = true
  access_log_bucket            = "my-org-access-logs-us-east-1"
  access_log_prefix            = "app-data/"

  tags = {
    Project     = "aws-secure-baseline"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

## Security Defaults

- **Public access fully blocked**: All four S3 public access block settings are set to `true`.
- **Bucket-owner-enforced ownership**: ACLs are disabled; all objects are owned by the bucket account.
- **HTTPS-only bucket policy**: A `DenyInsecureTransport` statement rejects any request not using TLS (`aws:SecureTransport = false`).
- **SSE-S3 encryption by default**: All objects are encrypted at rest. Provide a `kms_key_arn` to upgrade to SSE-KMS with bucket key enabled.
- **Versioning enabled by default**: Protects against accidental deletion and overwrites.
- **Abort incomplete multipart uploads**: When lifecycle is enabled, incomplete uploads are cleaned up after 7 days.
- **force_destroy = false**: Prevents accidental destruction of buckets containing data in production.
