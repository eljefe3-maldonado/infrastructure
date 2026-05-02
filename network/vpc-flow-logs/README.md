# VPC Flow Logs Module

Enables VPC Flow Logs with configurable destination (S3 or CloudWatch Logs), traffic type, log format, and S3 partitioning options.

## Description

This module attaches a VPC Flow Log to an existing VPC. It supports both S3 and CloudWatch Logs destinations, custom log formats, and S3-specific options such as Parquet file format and Hive-compatible partitioning for cost-efficient Athena querying.

## S3 vs CloudWatch Logs

- **S3** (default): Lower cost, better for long-term retention and bulk analysis via Athena or S3 Select. Requires a pre-existing S3 bucket with the appropriate bucket policy allowing `vpc-flow-logs.amazonaws.com` to write objects.
- **CloudWatch Logs**: Better for real-time alerting and metric filters. Requires an IAM role that grants the flow logs service permission to write to the log group.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| vpc_id | string | required | VPC ID to enable flow logs for |
| vpc_name | string | required | VPC name used in resource naming |
| destination_type | string | "s3" | Flow logs destination type: s3 or cloud-watch-logs |
| s3_bucket_arn | string | "" | S3 bucket ARN. Required when destination_type = s3 |
| s3_key_prefix | string | "" | S3 key prefix for flow logs |
| log_group_arn | string | "" | CloudWatch Logs group ARN. Required when destination_type = cloud-watch-logs |
| iam_role_arn | string | "" | IAM role ARN for CloudWatch delivery |
| traffic_type | string | "ALL" | ACCEPT, REJECT, or ALL |
| log_format | string | "" | Custom flow log format. Empty = AWS default |
| aggregation_interval | number | 600 | Max aggregation interval in seconds: 60 or 600 |
| file_format | string | "plain-text" | plain-text or parquet |
| hive_compatible_partitions | bool | false | Use Hive-compatible S3 partitions |
| per_hour_partition | bool | false | Partition logs by hour |
| tags | map(string) | {} | Tags applied to flow log resources |

## Outputs

| Name | Description |
|------|-------------|
| flow_log_id | VPC Flow Log ID |
| flow_log_arn | VPC Flow Log ARN |

## Example Usage

```hcl
module "vpc_flow_logs" {
  source = "../../network/vpc-flow-logs"

  vpc_id   = module.vpc.vpc_id
  vpc_name = "prod-us-east-1"

  destination_type = "s3"
  s3_bucket_arn    = "arn:aws:s3:::my-flow-logs-bucket"
  s3_key_prefix    = "vpc-flow-logs/"

  traffic_type         = "ALL"
  aggregation_interval = 60
  file_format          = "parquet"

  hive_compatible_partitions = true
  per_hour_partition         = true

  tags = {
    Project     = "aws-secure-baseline"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- S3 is the preferred destination for cost and Athena querying.
- Parquet format is recommended for high-volume environments — it significantly reduces Athena scan costs and improves query performance.
- When using S3, the target bucket must have a resource policy that grants `vpc-flow-logs.amazonaws.com` the `s3:PutObject` permission.
- When using CloudWatch Logs, `iam_role_arn` must reference a role with `logs:CreateLogGroup`, `logs:CreateLogStream`, and `logs:PutLogEvents` permissions.
