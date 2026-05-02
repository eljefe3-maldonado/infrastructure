data "aws_partition" "current" {}
data "aws_region" "current" {}

resource "aws_securityhub_account" "this" {
  count = var.enable ? 1 : 0

  enable_default_standards  = false
  auto_enable_controls      = var.auto_enable_controls
  control_finding_generator = var.control_finding_generator
}

resource "aws_securityhub_organization_admin_account" "this" {
  count = var.enable && var.delegated_admin_account_id != "" ? 1 : 0

  admin_account_id = var.delegated_admin_account_id

  depends_on = [aws_securityhub_account.this]
}

resource "aws_securityhub_organization_configuration" "this" {
  count = var.enable && var.delegated_admin_account_id != "" ? 1 : 0

  auto_enable           = var.auto_enable_org_members == "DEFAULT"
  auto_enable_standards = var.auto_enable_org_members

  depends_on = [aws_securityhub_organization_admin_account.this]
}

resource "aws_securityhub_standards_subscription" "cis" {
  count = var.enable && var.enable_cis_standard ? 1 : 0

  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"

  depends_on = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  count = var.enable && var.enable_fsbp_standard ? 1 : 0

  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "pci_dss" {
  count = var.enable && var.enable_pci_dss_standard ? 1 : 0

  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"

  depends_on = [aws_securityhub_account.this]
}
