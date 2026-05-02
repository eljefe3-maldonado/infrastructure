# CI/CD Validation

GitHub Actions workflow: `.github/workflows/terraform-validate.yml`

## Jobs

| Job | Purpose |
| --- | --- |
| `format` | Runs `terraform fmt -check -recursive`. |
| `validate` | Initializes and validates selected Terraform roots with `-backend=false`. |
| `checkov` | Runs Checkov against Terraform. |
| `tfsec` | Runs tfsec. |
| `opa` | Runs Conftest policies from `policies/opa`; currently non-blocking. |

## Validated Roots

- `bootstrap/remote-state`
- `environments/log-archive`
- `environments/dev`
- `environments/security`

## Plan Behavior

Plan runs are gated on `secrets.AWS_ROLE_ARN`. When the secret is absent, CI still runs format, init, validate, Checkov, tfsec, and OPA checks, but skips live AWS plans.

When enabled, the workflow uses GitHub OIDC through `aws-actions/configure-aws-credentials@v4` and posts plan output to pull requests with `marocchino/sticky-pull-request-comment@v2`.

## Required GitHub Secret

```text
AWS_ROLE_ARN
```

The role should be assumable by GitHub OIDC and should have read/plan permissions appropriate to the target AWS account. Do not grant apply permissions unless a separate, explicitly reviewed deployment workflow is added.

## Safety Rules

- The workflow does not auto-apply.
- Backend initialization is disabled in CI validation.
- Plans use example tfvars when present.
- OPA is non-blocking until policies are mature enough to gate changes.
