# Dev Environment

Development VPC and baseline infrastructure. References the central log-archive bucket for
VPC flow logs. All traffic (ingress + egress) is captured in Parquet format with
hive-compatible partitioning for cost-effective querying via Athena.

## Deploy After

1. `bootstrap/remote-state`
2. `environments/log-archive`

## Deployment

```bash
# 1. Initialise with remote state backend
terraform init -backend-config=backend.hcl

# 2. Review the plan
terraform plan -var-file=terraform.tfvars

# 3. Apply
terraform apply -var-file=terraform.tfvars
```

Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in account-specific values
before running the commands above. Never commit the populated `terraform.tfvars` file.
