data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowBreakGlassAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.principal_arns
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "NumericLessThan"
        variable = "aws:MultiFactorAuthAge"
        values   = [tostring(var.mfa_age_seconds)]
      }
    }
  }
}

resource "aws_iam_role" "break_glass" {
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  permissions_boundary = var.permission_boundary_arn != "" ? var.permission_boundary_arn : null

  tags = var.tags
}

# AdministratorAccess is intentional — this is the break-glass role
# Access to this role must be tightly controlled via the assume_role policy
# and its usage must generate CloudTrail events for audit
resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.break_glass.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess"
}

# CloudWatch alarm SNS notification is expected externally
# This role intentionally has no inline policies beyond AdministratorAccess
