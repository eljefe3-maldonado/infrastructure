module "org_trail" {
  source = "../../security/cloudtrail-org"

  trail_name                       = var.org_trail_name
  s3_bucket_name                   = var.log_archive_bucket_name
  s3_key_prefix                    = "cloudtrail"
  kms_key_arn                      = var.log_archive_kms_key_arn
  is_organization_trail            = true
  is_multi_region_trail            = true
  include_global_service_events    = true
  enable_log_file_validation       = true
  management_event_read_write_type = "All"
  tags                             = var.tags
}

module "guardduty" {
  source = "../../security/guardduty-org"

  detector_enable                       = var.enable_guardduty
  finding_publishing_frequency          = "SIX_HOURS"
  datasources_enable_s3                 = true
  datasources_enable_kubernetes         = true
  datasources_enable_malware_protection = true
  delegated_admin_account_id            = var.guardduty_delegated_admin_account_id
  auto_enable_org_members               = "ALL"
  tags                                  = var.tags
}

module "security_hub" {
  source = "../../security/security-hub-org"

  enable                     = var.enable_security_hub
  delegated_admin_account_id = var.security_hub_delegated_admin_account_id
  enable_cis_standard        = true
  enable_fsbp_standard       = true
  enable_pci_dss_standard    = false
  auto_enable_controls       = true
  tags                       = var.tags
}

module "access_analyzer" {
  source = "../../security/access-analyzer"

  analyzer_name = "security-account-analyzer"
  analyzer_type = var.access_analyzer_type
  tags          = var.tags
}
