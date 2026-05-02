resource "aws_flow_log" "this" {
  vpc_id                   = var.vpc_id
  traffic_type             = var.traffic_type
  iam_role_arn             = var.destination_type == "cloud-watch-logs" ? var.iam_role_arn : null
  log_destination          = var.destination_type == "s3" ? var.s3_bucket_arn : var.log_group_arn
  log_destination_type     = var.destination_type
  log_format               = var.log_format != "" ? var.log_format : null
  max_aggregation_interval = var.aggregation_interval

  dynamic "destination_options" {
    for_each = var.destination_type == "s3" ? [1] : []
    content {
      file_format                = var.file_format
      hive_compatible_partitions = var.hive_compatible_partitions
      per_hour_partition         = var.per_hour_partition
    }
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-flow-logs"
  })
}
