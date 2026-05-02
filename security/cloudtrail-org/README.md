# CloudTrail Organization Module

Deploys an AWS CloudTrail trail with optional organization-wide coverage, multi-region support, KMS encryption, and CloudWatch Logs delivery.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| trail_name | Organization CloudTrail name | string | — | yes |
| s3_bucket_name | S3 bucket for CloudTrail logs. Must already exist with CloudTrail delivery permissions | string | — | yes |
| kms_key_arn | KMS key ARN for CloudTrail log encryption | string | — | yes |
| is_organization_trail | Enable organization-level trail | bool | true | no |
| enable_log_file_validation | Enable log file integrity validation | bool | true | no |
| is_multi_region_trail | Deploy as a multi-region trail | bool | true | no |
| include_global_service_events | Include global service events (IAM, STS, etc.) | bool | true | no |
| management_event_read_write_type | ReadWriteType for management events: ReadOnly, WriteOnly, or All | string | "All" | no |
| cloudwatch_log_group_arn | CloudWatch Logs group ARN. Leave empty to skip CW Logs delivery | string | "" | no |
| cloudwatch_role_arn | IAM role ARN for CloudTrail to write to CloudWatch Logs | string | "" | no |
| data_resource_types | Optional list of data resource types | list(string) | [] | no |
| s3_key_prefix | Optional S3 key prefix for CloudTrail logs | string | "" | no |
| enable_management_events | Record management events | bool | true | no |
| tags | Tags applied to trail resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| trail_arn | CloudTrail trail ARN |
| trail_name | CloudTrail trail name |
| trail_home_region | Home region of the CloudTrail trail |

## Example Usage

```hcl
module "org_trail" {
  source = "../../security/cloudtrail-org"

  trail_name     = "org-trail"
  s3_bucket_name = "my-log-archive-bucket"
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/mrk-abc123"

  is_organization_trail = true
  is_multi_region_trail = true

  tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- `is_organization_trail` requires the calling account to be the AWS Organizations management account or delegated admin.
- The S3 bucket must be pre-created with a bucket policy allowing `cloudtrail.amazonaws.com` to call `s3:GetBucketAcl` and `s3:PutObject`. Use the `log-archive-buckets` module with `allow_cloudtrail_delivery = true`.
- To deliver to CloudWatch Logs, supply both `cloudwatch_log_group_arn` and `cloudwatch_role_arn`.
