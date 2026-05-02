variable "aws_region" {
  type        = string
  description = "AWS region for dev resources"
}

variable "vpc_name" {
  type        = string
  default     = "dev-vpc"
  description = "VPC name"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.10.0.0/16"
  description = "VPC CIDR block"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones. Minimum 2 recommended"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "Public subnet CIDR blocks (one per AZ)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR blocks (one per AZ)"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Enable NAT gateway for private subnet internet access"
}

variable "log_archive_bucket_name" {
  type        = string
  description = "Centralized log archive S3 bucket name for VPC flow logs"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all dev environment resources"
}
