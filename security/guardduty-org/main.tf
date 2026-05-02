data "aws_caller_identity" "current" {}

resource "aws_guardduty_detector" "this" {
  enable                       = var.detector_enable
  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.datasources_enable_s3
    }
    kubernetes {
      audit_logs {
        enable = var.datasources_enable_kubernetes
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.datasources_enable_malware_protection
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_guardduty_organization_admin_account" "this" {
  count = var.delegated_admin_account_id != "" ? 1 : 0

  admin_account_id = var.delegated_admin_account_id

  depends_on = [aws_guardduty_detector.this]
}

resource "aws_guardduty_organization_configuration" "this" {
  count = var.delegated_admin_account_id != "" ? 1 : 0

  auto_enable_organization_members = var.auto_enable_org_members
  detector_id                      = aws_guardduty_detector.this.id

  datasources {
    s3_logs {
      auto_enable = var.enable_s3_logs_for_org
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_for_org
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.enable_malware_protection_for_org
        }
      }
    }
  }

  depends_on = [aws_guardduty_organization_admin_account.this]
}
