data "aws_partition" "current" {}

locals {
  s3_public_access_block_settings = [
    "BlockPublicAcls",
    "IgnorePublicAcls",
    "BlockPublicPolicy",
    "RestrictPublicBuckets",
  ]
}

# SCP: Deny root account actions
data "aws_iam_policy_document" "deny_root" {
  count = var.deny_root_account ? 1 : 0

  statement {
    sid       = "DenyRootAccountActions"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:${data.aws_partition.current.partition}:iam::*:root"]
    }
  }
}

resource "aws_organizations_policy" "deny_root" {
  count = var.deny_root_account ? 1 : 0

  name        = "deny-root-account-actions"
  description = "Prevents root account actions in all member accounts"
  content     = data.aws_iam_policy_document.deny_root[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_root" {
  for_each = var.deny_root_account ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.deny_root[0].id
  target_id = each.value
}

# SCP: Deny leaving the organization
data "aws_iam_policy_document" "deny_leave_org" {
  count = var.deny_leaving_org ? 1 : 0

  statement {
    sid       = "DenyLeavingOrganization"
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_leave_org" {
  count = var.deny_leaving_org ? 1 : 0

  name        = "deny-leaving-organization"
  description = "Prevents member accounts from leaving the AWS organization"
  content     = data.aws_iam_policy_document.deny_leave_org[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_leave_org" {
  for_each = var.deny_leaving_org ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.deny_leave_org[0].id
  target_id = each.value
}

# SCP: Deny S3 public access block removal
data "aws_iam_policy_document" "deny_public_s3" {
  count = var.deny_public_s3 ? 1 : 0

  dynamic "statement" {
    for_each = toset(local.s3_public_access_block_settings)
    content {
      sid    = "DenyBucketPublicAccess${statement.value}Disabled"
      effect = "Deny"
      actions = [
        "s3:PutBucketPublicAccessBlock",
        "s3:DeletePublicAccessBlock",
      ]
      resources = ["*"]

      condition {
        test     = "BoolIfExists"
        variable = "s3:publicAccessBlockConfiguration/${statement.value}"
        values   = ["false"]
      }
    }
  }

  dynamic "statement" {
    for_each = toset(local.s3_public_access_block_settings)
    content {
      sid       = "DenyAccountPublicAccess${statement.value}Disabled"
      effect    = "Deny"
      actions   = ["s3:PutAccountPublicAccessBlock"]
      resources = ["*"]

      condition {
        test     = "BoolIfExists"
        variable = "s3:publicAccessBlockConfiguration/${statement.value}"
        values   = ["false"]
      }
    }
  }
}

resource "aws_organizations_policy" "deny_public_s3" {
  count = var.deny_public_s3 ? 1 : 0

  name        = "deny-s3-public-access-modification"
  description = "Prevents removing S3 public access block settings"
  content     = data.aws_iam_policy_document.deny_public_s3[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_public_s3" {
  for_each = var.deny_public_s3 ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.deny_public_s3[0].id
  target_id = each.value
}

# SCP: Deny unapproved regions
data "aws_iam_policy_document" "deny_unapproved_regions" {
  count = var.deny_unapproved_regions ? 1 : 0

  statement {
    sid    = "DenyUnapprovedRegions"
    effect = "Deny"
    not_actions = [
      # Global and IAM services must always be accessible
      "iam:*",
      "organizations:*",
      "support:*",
      "sts:*",
      "cloudfront:*",
      "route53:*",
      "route53domains:*",
      "waf:*",
      "budgets:*",
      "ce:*",
      "globalaccelerator:*",
      "health:*",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "account:*",
    ]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.approved_regions
    }

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:${data.aws_partition.current.partition}:iam::*:role/aws-reserved/*",
      ]
    }
  }
}

resource "aws_organizations_policy" "deny_unapproved_regions" {
  count = var.deny_unapproved_regions ? 1 : 0

  name        = "deny-unapproved-regions"
  description = "Restricts API calls to approved AWS regions"
  content     = data.aws_iam_policy_document.deny_unapproved_regions[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_unapproved_regions" {
  for_each = var.deny_unapproved_regions ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.deny_unapproved_regions[0].id
  target_id = each.value
}

# SCP: Require IMDSv2
data "aws_iam_policy_document" "require_imdsv2" {
  count = var.require_imdsv2 ? 1 : 0

  statement {
    sid    = "DenyIMDSv1"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:ModifyInstanceMetadataOptions",
    ]
    resources = ["arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*"]

    condition {
      test     = "StringNotEquals"
      variable = "ec2:MetadataHttpTokens"
      values   = ["required"]
    }
  }
}

resource "aws_organizations_policy" "require_imdsv2" {
  count = var.require_imdsv2 ? 1 : 0

  name        = "require-imdsv2"
  description = "Requires EC2 instances to use IMDSv2 (token-based metadata)"
  content     = data.aws_iam_policy_document.require_imdsv2[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "require_imdsv2" {
  for_each = var.require_imdsv2 ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.require_imdsv2[0].id
  target_id = each.value
}

# SCP: Deny CloudTrail disable or modification
data "aws_iam_policy_document" "deny_cloudtrail_disable" {
  count = var.deny_cloudtrail_disable ? 1 : 0

  statement {
    sid    = "DenyCloudTrailModification"
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
      "cloudtrail:PutEventSelectors",
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_cloudtrail_disable" {
  count = var.deny_cloudtrail_disable ? 1 : 0

  name        = "deny-cloudtrail-modification"
  description = "Prevents disabling or modifying CloudTrail in member accounts"
  content     = data.aws_iam_policy_document.deny_cloudtrail_disable[0].json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "deny_cloudtrail_disable" {
  for_each = var.deny_cloudtrail_disable ? toset(var.target_ou_ids) : toset([])

  policy_id = aws_organizations_policy.deny_cloudtrail_disable[0].id
  target_id = each.value
}
