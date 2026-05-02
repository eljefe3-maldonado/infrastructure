module "vpc" {
  source = "../../network/vpc-baseline"

  vpc_name                = var.vpc_name
  cidr_block              = var.vpc_cidr_block
  availability_zones      = var.availability_zones
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = true
  map_public_ip_on_launch = false
  tags                    = var.tags
}

module "vpc_flow_logs" {
  source = "../../network/vpc-flow-logs"

  vpc_id                     = module.vpc.vpc_id
  vpc_name                   = var.vpc_name
  destination_type           = "s3"
  s3_bucket_arn              = "arn:aws:s3:::${var.log_archive_bucket_name}"
  s3_key_prefix              = "vpc-flow-logs/dev/"
  traffic_type               = "ALL"
  file_format                = "parquet"
  hive_compatible_partitions = true
  per_hour_partition         = true
  tags                       = var.tags
}
