module "log_archive_kms_key" {
  source = "../../logging/kms-keys"

  description = "KMS key for centralized AWS log archive"
  alias_name  = "log-archive"
  allowed_service_principals = compact([
    var.allow_cloudtrail_delivery ? "cloudtrail.amazonaws.com" : "",
    var.allow_vpc_flow_logs_delivery ? "delivery.logs.amazonaws.com" : "",
    var.allow_config_delivery ? "config.amazonaws.com" : "",
  ])
  tags = var.tags
}

module "log_archive_bucket" {
  source = "../../logging/log-archive-buckets"

  bucket_name                  = var.log_archive_bucket_name
  kms_key_arn                  = module.log_archive_kms_key.key_arn
  allow_cloudtrail_delivery    = var.allow_cloudtrail_delivery
  allow_vpc_flow_logs_delivery = var.allow_vpc_flow_logs_delivery
  allow_config_delivery        = var.allow_config_delivery
  delivery_source_account_ids  = var.delivery_source_account_ids
  org_id                       = var.org_id
  tags                         = var.tags
}
