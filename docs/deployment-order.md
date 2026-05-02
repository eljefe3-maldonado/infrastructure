# Deployment Order

Use this order for a new AWS baseline. Run `terraform plan` and review every step before apply.

## 1. Bootstrap Remote State

Root: `bootstrap/remote-state`

Creates:

- S3 Terraform state bucket.
- DynamoDB lock table.
- KMS key for state encryption.

Example:

```bash
cd bootstrap/remote-state
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -var-file=terraform.tfvars
```

Apply only after the bucket name, region, KMS alias, tags, and lock table name are reviewed.

## 2. Configure Backends

Create `backend.hcl` files from each `backend.hcl.example`. Keep real backend files out of git.

Use a unique state key per root:

```text
environments/log-archive/terraform.tfstate
environments/security/terraform.tfstate
environments/dev/terraform.tfstate
```

## 3. Deploy Log Archive

Root: `environments/log-archive`

Creates:

- Central log archive KMS key.
- Central log archive S3 bucket.
- Optional delivery permissions for CloudTrail, Config, and VPC Flow Logs.
- Optional organization-only access guardrail using `org_id`.

Start with delivery toggles disabled. Enable each delivery permission as the corresponding service is deployed.

## 4. Deploy Security Environment

Root: `environments/security`

Creates:

- Organization CloudTrail.
- GuardDuty detector and optional organization configuration.
- Security Hub and selected standards.
- IAM Access Analyzer.

Prerequisites:

- Log archive bucket exists.
- Log archive KMS key permits required service principals.
- CloudTrail delivery is enabled on the log archive bucket.
- Delegated administrator account IDs are reviewed.

## 5. Deploy Organization Guardrails

Root/module: `org/scps`

Attach SCPs first to a sandbox OU. After testing, promote to broader OUs.

Current SCP examples:

- Deny root account actions.
- Deny leaving the organization.
- Deny weakening S3 Public Access Block.
- Deny unapproved regions.
- Require EC2 IMDSv2.
- Deny CloudTrail modification.

## 6. Deploy Identity Guardrails

Root/module: `identity/break-glass`

Create break-glass access only after:

- Trusted principal ARNs are reviewed.
- MFA is enforced.
- CloudTrail monitoring is deployed.
- Incident response process is documented.

## 7. Deploy Workload Environments

Root: `environments/dev`

Creates:

- VPC.
- Public and private subnets.
- Optional NAT gateway.
- Locked-down default security group.
- VPC Flow Logs to S3.

After dev is reviewed, build `test` and `prod` from the same pattern with stricter production variables.
