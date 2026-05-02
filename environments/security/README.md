# Security Account Environment

Provisions organization-level security services: CloudTrail (org trail), GuardDuty,
Security Hub, and IAM Access Analyzer. This root should be deployed from the management
account or from the designated security account that holds delegated-admin privileges.

## Deploy After

1. `bootstrap/remote-state`
2. `environments/log-archive` — the log-archive KMS key ARN and bucket name are required inputs

## Deployment Order

```
bootstrap/remote-state  →  environments/log-archive  →  environments/security
```

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

## Notes

- The organization CloudTrail (`org_trail`) **must** be created from the management account
  (or an account with `cloudtrail:CreateTrail` delegated). Attempting to create an org trail
  from a member account without the correct SCP exception will fail.
- Set `guardduty_delegated_admin_account_id` and `security_hub_delegated_admin_account_id`
  only when running from the management account to designate a separate security account.
  Leave both empty when running directly from the security/delegated-admin account.
