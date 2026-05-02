# VPC Baseline Module

Provisions a secure VPC with public/private subnet separation, optional NAT gateway, locked-down default security group, and resource tagging.

## Description

This module creates a production-ready VPC following AWS security best practices. It supports optional public and private subnets spread across multiple availability zones, an internet gateway for public tiers, and NAT gateways for private subnet egress. The AWS default security group is immediately locked down on creation.

## Security Design

- **Default security group locked down**: The VPC default security group is taken under management and stripped of all ingress and egress rules, replacing the permissive AWS default that allows all traffic within the security group.
- **No auto-assign public IPs**: `map_public_ip_on_launch` defaults to `false`. Instances must have Elastic IPs or sit behind load balancers to reach the internet.
- **Single NAT gateway for cost optimization**: `single_nat_gateway = true` by default — suitable for non-production workloads. Set to `false` for HA in production.
- **Internet gateway created on demand**: Only provisioned when `public_subnet_cidrs` is non-empty, keeping fully private VPCs clean.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| vpc_name | string | required | VPC name used in resource naming and tagging |
| cidr_block | string | required | VPC CIDR block |
| enable_dns_hostnames | bool | true | Enable DNS hostnames |
| enable_dns_support | bool | true | Enable DNS support |
| public_subnet_cidrs | list(string) | [] | Public subnet CIDR blocks, one per AZ |
| private_subnet_cidrs | list(string) | [] | Private subnet CIDR blocks, one per AZ |
| availability_zones | list(string) | required | Availability zones — must match subnet CIDR count |
| enable_nat_gateway | bool | false | Deploy a NAT gateway for private subnet internet access |
| single_nat_gateway | bool | true | Use one NAT gateway for all private subnets |
| map_public_ip_on_launch | bool | false | Auto-assign public IP on launch in public subnets |
| tags | map(string) | {} | Tags applied to all VPC resources |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_arn | VPC ARN |
| vpc_cidr_block | VPC CIDR block |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| public_route_table_id | Public route table ID |
| private_route_table_ids | List of private route table IDs |
| nat_gateway_ids | List of NAT gateway IDs |
| internet_gateway_id | Internet gateway ID |
| default_security_group_id | Default security group ID (locked down) |

## Example Usage

```hcl
module "vpc" {
  source = "../../network/vpc-baseline"

  vpc_name   = "prod-us-east-1"
  cidr_block = "10.0.0.0/16"

  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false # One NAT GW per AZ for HA

  tags = {
    Project     = "aws-secure-baseline"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```
