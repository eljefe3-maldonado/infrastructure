# AWS Config Organization Module

Configures the AWS Config configuration recorder, delivery channel, and IAM role. Can be deployed per-account to enable resource configuration tracking and snapshot delivery to a central S3 bucket.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| s3_bucket_name | S3 bucket for Config snapshots | string | — | yes |
| config_recorder_name | AWS Config recorder name | string | "default" | no |
| delivery_channel_name | AWS Config delivery channel name | string | "default" | no |
| s3_key_prefix | Optional S3 key prefix | string | "" | no |
| kms_key_arn | Optional KMS key ARN for Config encryption | string | "" | no |
| sns_topic_arn | Optional SNS topic ARN for Config notifications | string | "" | no |
| delivery_frequency | Config snapshot delivery frequency | string | "TwentyFour_Hours" | no |
| include_global_resource_types | Include global IAM resources in recording | bool | true | no |
| create_iam_role | Create the IAM role for AWS Config | bool | true | no |
| iam_role_arn | Existing IAM role ARN. Used when create_iam_role = false | string | "" | no |
| delegated_admin_account_id | Account ID to delegate Config admin. Leave empty to skip | string | "" | no |
| tags | Tags applied to Config resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| recorder_id | AWS Config configuration recorder ID |
| delivery_channel_id | AWS Config delivery channel ID |
| config_role_arn | IAM role ARN used by AWS Config |

## Example Usage

```hcl
module "aws_config" {
  source = "../../security/config-org"

  s3_bucket_name = "my-log-archive-bucket"
  s3_key_prefix  = "config"

  tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- The S3 bucket must allow `config.amazonaws.com` to call `s3:GetBucketAcl`, `s3:PutObject`, and `s3:GetEncryptionConfiguration`. Use the `log-archive-buckets` module with `allow_config_delivery = true`.
- Set `create_iam_role = false` and provide `iam_role_arn` when managing the IAM role externally.
- Only one configuration recorder is allowed per region per account. If one already exists, import it before applying.
- `include_global_resource_types` should only be `true` in one region per account (typically `us-east-1`) to avoid duplicate global resource recordings.
