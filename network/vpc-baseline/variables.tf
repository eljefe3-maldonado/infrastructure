variable "vpc_name" {
  type        = string
  description = "VPC name used in resource naming and tagging"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "List of public subnet CIDR blocks. One per AZ"

  validation {
    condition     = length(var.public_subnet_cidrs) == 0 || length(var.public_subnet_cidrs) <= length(var.availability_zones)
    error_message = "public_subnet_cidrs cannot contain more entries than availability_zones."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "List of private subnet CIDR blocks. One per AZ"

  validation {
    condition     = length(var.private_subnet_cidrs) == 0 || length(var.private_subnet_cidrs) <= length(var.availability_zones)
    error_message = "private_subnet_cidrs cannot contain more entries than availability_zones."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones. Must match the number of subnet CIDRs"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Deploy a NAT gateway for private subnet internet access"

  validation {
    condition     = !var.enable_nat_gateway || length(var.public_subnet_cidrs) > 0
    error_message = "enable_nat_gateway requires at least one public subnet CIDR."
  }
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use a single NAT gateway for all private subnets (cost optimization for non-prod)"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "Auto-assign public IP on launch in public subnets. Keep false for security"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all VPC resources"
}
