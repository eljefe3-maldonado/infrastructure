# Operations Guide

## Local Validation

Run formatting from the repository root:

```bash
terraform fmt -recursive
```

Validate individual roots:

```bash
terraform -chdir=bootstrap/remote-state init -backend=false
terraform -chdir=bootstrap/remote-state validate

terraform -chdir=environments/log-archive init -backend=false
terraform -chdir=environments/log-archive validate

terraform -chdir=environments/security init -backend=false
terraform -chdir=environments/security validate

terraform -chdir=environments/dev init -backend=false
terraform -chdir=environments/dev validate
```

## Planning

After backend configuration exists:

```bash
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
```

Do not commit real `backend.hcl`, `terraform.tfvars`, plans, state, or `.terraform/`.

## Applying

Apply only after plan review:

```bash
terraform apply
```

High-risk changes need additional review:

- SCP attachment or changes.
- KMS key policies.
- Organization delegated administrator changes.
- CloudTrail changes.
- Public network routes.
- Break-glass role trust policy changes.

## Drift And Review

Use `terraform plan` as the primary drift check. For production, run plans from CI or a controlled platform role, not from long-lived personal credentials.

## Tagging

At minimum, use:

```hcl
tags = {
  Project     = "aws-secure-baseline"
  Environment = "dev"
  ManagedBy   = "terraform"
}
```

OPA policy currently checks these tags on selected resource types.
