# GuardDuty Organization Module

Enables AWS GuardDuty with threat intelligence datasources (S3, Kubernetes, EBS malware protection) and optionally delegates org administration to a security account.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| detector_enable | Enable the GuardDuty detector | bool | true | no |
| finding_publishing_frequency | Frequency of findings publication: FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS | string | "SIX_HOURS" | no |
| datasources_enable_s3 | Enable S3 protection | bool | true | no |
| datasources_enable_kubernetes | Enable Kubernetes audit logs protection | bool | true | no |
| datasources_enable_malware_protection | Enable EBS malware protection | bool | true | no |
| delegated_admin_account_id | Account ID to delegate GuardDuty administration. Leave empty to skip | string | "" | no |
| auto_enable_org_members | How to auto-enable members: ALL, NEW, or NONE | string | "ALL" | no |
| enable_s3_logs_for_org | Auto-enable S3 logs for org members | bool | true | no |
| enable_kubernetes_for_org | Auto-enable Kubernetes protection for org members | bool | true | no |
| enable_malware_protection_for_org | Auto-enable malware protection for org members | bool | true | no |
| tags | Tags applied to GuardDuty resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| detector_id | GuardDuty detector ID |
| detector_arn | GuardDuty detector ARN |
| account_id | AWS account ID where the detector was created |

## Example Usage

```hcl
module "guardduty" {
  source = "../../security/guardduty-org"

  delegated_admin_account_id = "111122223333"
  auto_enable_org_members    = "ALL"

  tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- Run this module in the management account.
- Set `delegated_admin_account_id` to your security account ID to delegate administration.
- Organization configuration resources are only created when `delegated_admin_account_id` is non-empty.
- GuardDuty must be enabled in the delegated admin account separately before org members can be managed from there.
