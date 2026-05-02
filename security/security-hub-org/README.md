# Security Hub Organization Module

Enables AWS Security Hub, subscribes to CIS and FSBP standards, and optionally delegates org administration to a security account.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| enable | Enable Security Hub | bool | true | no |
| auto_enable_controls | Auto-enable Security Hub controls | bool | true | no |
| control_finding_generator | Finding generator mode: SECURITY_CONTROL or STANDARD_CONTROL | string | "SECURITY_CONTROL" | no |
| delegated_admin_account_id | Security account ID to delegate admin. Leave empty to skip | string | "" | no |
| auto_enable_org_members | How to auto-enroll org members: DEFAULT or NONE | string | "DEFAULT" | no |
| enable_cis_standard | Enable CIS AWS Foundations Benchmark standard | bool | true | no |
| enable_fsbp_standard | Enable AWS Foundational Security Best Practices standard | bool | true | no |
| enable_pci_dss_standard | Enable PCI DSS standard | bool | false | no |
| tags | Tags (note: Security Hub itself is not taggable) | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| account_id | Security Hub account resource ID |
| cis_subscription_arn | CIS AWS Foundations Benchmark subscription ARN |
| fsbp_subscription_arn | AWS Foundational Security Best Practices subscription ARN |

## Example Usage

```hcl
module "security_hub" {
  source = "../../security/security-hub-org"

  delegated_admin_account_id = "111122223333"
  auto_enable_org_members    = "DEFAULT"

  enable_cis_standard  = true
  enable_fsbp_standard = true
  enable_pci_dss_standard = false

  tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- Run this module in the management account to delegate administration to a security account.
- `enable_default_standards` is set to `false` to allow explicit control over which standards are subscribed.
- Standards subscriptions are created in the account and region where this module is applied. For org-wide coverage, the delegated admin account manages member account standards.
- The CIS standard ARN uses the global ruleset format (no region component); FSBP and PCI DSS use regional ARNs.
