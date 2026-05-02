# IAM Access Analyzer Module

Deploys an AWS IAM Access Analyzer at ACCOUNT or ORGANIZATION scope, with optional archive rules to suppress known-good findings.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| analyzer_name | IAM Access Analyzer name | string | — | yes |
| analyzer_type | ACCOUNT or ORGANIZATION. ORGANIZATION requires AWS Organizations | string | "ORGANIZATION" | no |
| archive_rules | List of archive rules to suppress known-good findings | list(object) | [] | no |
| tags | Tags applied to Access Analyzer resources | map(string) | {} | no |

### archive_rules object schema

```
list(object({
  rule_name = string
  filter = list(object({
    criteria = string
    eq       = optional(list(string), [])
    neq      = optional(list(string), [])
    exists   = optional(bool)
  }))
}))
```

## Outputs

| Name | Description |
|------|-------------|
| analyzer_arn | IAM Access Analyzer ARN |
| analyzer_name | IAM Access Analyzer name |

## Example Usage

```hcl
module "access_analyzer" {
  source = "../../security/access-analyzer"

  analyzer_name = "org-analyzer"
  analyzer_type = "ORGANIZATION"

  archive_rules = [
    {
      rule_name = "suppress-known-s3-access"
      filter = [
        {
          criteria = "resourceType"
          eq       = ["AWS::S3::Bucket"]
        },
        {
          criteria = "principal.AWS"
          eq       = ["arn:aws:iam::123456789012:role/known-role"]
        }
      ]
    }
  ]

  tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- `ORGANIZATION` type requires the calling account to be the AWS Organizations management account or delegated administrator for Access Analyzer.
- Only one organization-level analyzer is needed per region. Account-level analyzers can be deployed in each member account.
- Archive rules match findings using filter criteria. Use `eq` for exact matches, `neq` for exclusions, and `exists` to check for the presence of a field.
