data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

resource "aws_cloudtrail" "this" {
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix != "" ? var.s3_key_prefix : null
  kms_key_id                    = var.kms_key_arn
  enable_log_file_validation    = var.enable_log_file_validation
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail

  cloud_watch_logs_group_arn = var.cloudwatch_log_group_arn != "" ? "${var.cloudwatch_log_group_arn}:*" : null
  cloud_watch_logs_role_arn  = var.cloudwatch_role_arn != "" ? var.cloudwatch_role_arn : null

  dynamic "event_selector" {
    for_each = var.enable_management_events ? [1] : []
    content {
      read_write_type           = var.management_event_read_write_type
      include_management_events = true
    }
  }

  tags = var.tags
}
