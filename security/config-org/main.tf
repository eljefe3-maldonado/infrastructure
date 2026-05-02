data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "config_assume_role" {
  count = var.create_iam_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config" {
  count = var.create_iam_role ? 1 : 0

  name               = "aws-config-recorder-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role[0].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "config" {
  count = var.create_iam_role ? 1 : 0

  role       = aws_iam_role.config[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

locals {
  config_role_arn = var.create_iam_role ? aws_iam_role.config[0].arn : var.iam_role_arn
}

resource "aws_config_configuration_recorder" "this" {
  name     = var.config_recorder_name
  role_arn = local.config_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.include_global_resource_types
  }

  depends_on = [aws_iam_role_policy_attachment.config]
}

resource "aws_config_delivery_channel" "this" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix != "" ? var.s3_key_prefix : null
  sns_topic_arn  = var.sns_topic_arn != "" ? var.sns_topic_arn : null

  snapshot_delivery_properties {
    delivery_frequency = var.delivery_frequency
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}
