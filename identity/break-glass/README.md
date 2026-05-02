# Break-Glass IAM Role

Provisions a break-glass IAM role for emergency access to an AWS account.

## Security Design

- MFA is required by default to assume this role.
- The role carries `AdministratorAccess` — use only in genuine emergencies.
- All assumption attempts generate CloudTrail events. Set up an alarm on `AssumeRole` events for this role name.
- Rotate or revoke access to the principals listed in `principal_arns` regularly.
- Never store credentials that assume this role in automated systems.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| role_name | string | "break-glass" | IAM role name |
| principal_arns | list(string) | required | IAM principals that can assume this role |
| require_mfa | bool | true | Require MFA to assume |
| mfa_age_seconds | number | 3600 | Max MFA age in seconds |
| max_session_duration | number | 3600 | Max session duration in seconds |
| permission_boundary_arn | string | "" | Optional permission boundary |
| tags | map(string) | {} | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | Break-glass role ARN |
| role_name | Break-glass role name |
| role_unique_id | Break-glass role unique ID |

## Example Usage

```hcl
module "break_glass" {
  source = "../../identity/break-glass"

  role_name     = "break-glass"
  principal_arns = [
    "arn:aws:iam::111122223333:user/security-admin",
  ]
  require_mfa          = true
  mfa_age_seconds      = 3600
  max_session_duration = 3600

  tags = {
    Project     = "aws-secure-baseline"
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## CloudTrail Alarm

Create a CloudWatch metric filter and alarm on `AssumeRole` events where `requestParameters.roleArn` matches this role's ARN. See `docs/security-services.md` for details.
