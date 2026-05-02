data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.transition_ia_days
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.transition_glacier_days
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "expire-old-objects"
    status = var.enable_expiration ? "Enabled" : "Disabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.expiration_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  dynamic "statement" {
    for_each = var.allow_cloudtrail_delivery ? [1] : []
    content {
      sid    = "AllowCloudTrailAclCheck"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }

      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.this.arn]
    }
  }

  dynamic "statement" {
    for_each = var.allow_cloudtrail_delivery ? [1] : []
    content {
      sid    = "AllowCloudTrailWrite"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }

      actions = ["s3:PutObject"]
      resources = [
        "${aws_s3_bucket.this.arn}/*",
      ]

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      dynamic "condition" {
        for_each = length(var.delivery_source_account_ids) > 0 ? [1] : []
        content {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = var.delivery_source_account_ids
        }
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_vpc_flow_logs_delivery ? [1] : []
    content {
      sid    = "AllowVpcFlowLogsAclCheck"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.this.arn]
    }
  }

  dynamic "statement" {
    for_each = var.allow_vpc_flow_logs_delivery ? [1] : []
    content {
      sid    = "AllowVpcFlowLogsWrite"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.this.arn}/*"]

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      dynamic "condition" {
        for_each = length(var.delivery_source_account_ids) > 0 ? [1] : []
        content {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = var.delivery_source_account_ids
        }
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_config_delivery ? [1] : []
    content {
      sid    = "AllowConfigAclCheck"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }

      actions = [
        "s3:GetBucketAcl",
        "s3:GetEncryptionConfiguration",
      ]

      resources = [aws_s3_bucket.this.arn]
    }
  }

  dynamic "statement" {
    for_each = var.allow_config_delivery ? [1] : []
    content {
      sid    = "AllowConfigWrite"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }

      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.this.arn}/*"]

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      dynamic "condition" {
        for_each = length(var.delivery_source_account_ids) > 0 ? [1] : []
        content {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = var.delivery_source_account_ids
        }
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.allowed_account_ids) > 0 ? [1] : []
    content {
      sid    = "AllowCrossAccountAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = [for id in var.allowed_account_ids : "arn:${data.aws_partition.current.partition}:iam::${id}:root"]
      }

      actions = ["s3:PutObject"]

      resources = ["${aws_s3_bucket.this.arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.org_id != "" ? [1] : []
    content {
      sid    = "DenyNonOrgAccess"
      effect = "Deny"

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      actions = ["s3:*"]

      resources = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*",
      ]

      condition {
        test     = "StringNotEquals"
        variable = "aws:PrincipalOrgID"
        values   = [var.org_id]
      }

      condition {
        test     = "BoolIfExists"
        variable = "aws:PrincipalIsAWSService"
        values   = ["false"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
