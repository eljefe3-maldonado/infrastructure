# Service Control Policies (SCPs)

Provisions and attaches AWS Organizations Service Control Policies to enforce security guardrails across member accounts.

## Description

This module creates opt-in SCPs for common security baselines: blocking root account usage, preventing accounts from leaving the organization, enforcing S3 public access restrictions, restricting API calls to approved regions, requiring IMDSv2, and protecting CloudTrail from modification. Each SCP is independently toggle-able via boolean variables.

## Security Design

- All SCPs default to enabled except `deny_unapproved_regions`, which requires explicit region list configuration.
- The `deny_unapproved_regions` SCP uses `not_actions` to exempt IAM, STS, Route 53, CloudFront, and other inherently global services — ensuring those always remain accessible regardless of region restrictions.
- SCPs are attached to all OUs in `target_ou_ids`. Attach to the root OU for organization-wide coverage, or to specific OUs for targeted enforcement.
- SCP evaluation is additive with identity-based policies: the effective permissions are the intersection of both.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| deny_root_account | bool | true | Attach SCP denying root account actions |
| deny_leaving_org | bool | true | Attach SCP preventing accounts from leaving the org |
| deny_public_s3 | bool | true | Attach SCP denying S3 public access block removal |
| deny_unapproved_regions | bool | false | Attach SCP restricting API calls to approved regions |
| approved_regions | list(string) | ["us-east-1", "us-west-2"] | Allowed regions when deny_unapproved_regions = true |
| require_imdsv2 | bool | true | Attach SCP requiring IMDSv2 for EC2 instances |
| deny_cloudtrail_disable | bool | true | Attach SCP preventing CloudTrail modification |
| target_ou_ids | list(string) | required | OU IDs to attach SCPs to |
| tags | map(string) | {} | Tags applied to SCP resources |

## Outputs

| Name | Description |
|------|-------------|
| deny_root_policy_arn | ARN of the deny-root-account-actions SCP |
| deny_leave_org_policy_arn | ARN of the deny-leaving-organization SCP |
| deny_public_s3_policy_arn | ARN of the deny-s3-public-access-modification SCP |
| deny_unapproved_regions_policy_arn | ARN of the deny-unapproved-regions SCP |
| require_imdsv2_policy_arn | ARN of the require-imdsv2 SCP |
| deny_cloudtrail_disable_policy_arn | ARN of the deny-cloudtrail-modification SCP |

## Example Usage

```hcl
module "scps" {
  source = "../../org/scps"

  deny_root_account       = true
  deny_leaving_org        = true
  deny_public_s3          = true
  deny_unapproved_regions = true
  approved_regions        = ["us-east-1", "us-west-2"]
  require_imdsv2          = true
  deny_cloudtrail_disable = true

  target_ou_ids = [
    "ou-xxxx-yyyyyyyy",
    "ou-xxxx-zzzzzzzz",
  ]

  tags = {
    Project     = "aws-secure-baseline"
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```

## Notes

- SCPs must be applied from the AWS Organizations management account.
- You must enable All Features in your organization before applying SCPs.
- The `deny_unapproved_regions` SCP exempts IAM, STS, and other global services to prevent breaking cross-region control plane operations.
