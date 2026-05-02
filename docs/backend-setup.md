# Backend Setup

Run `bootstrap/remote-state` before enabling S3 backends in environment roots.

The bootstrap root intentionally has no backend block because it creates the backend resources. After it is applied, environment roots can initialize against the S3 backend.

Each environment should use a separate state key, for example:

```hcl
bucket         = "example-company-terraform-state"
key            = "environments/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
encrypt        = true
kms_key_id     = "arn:aws:kms:us-east-1:111122223333:key/example"
```

Keep real backend files out of git.

## Per-Root Backend Files

Each environment folder includes or should include a `backend.hcl.example`. Create a local `backend.hcl` next to it:

```bash
cp backend.hcl.example backend.hcl
```

Then initialize:

```bash
terraform init -backend-config=backend.hcl
```

## Recommended State Keys

| Root | State key |
| --- | --- |
| `environments/log-archive` | `environments/log-archive/terraform.tfstate` |
| `environments/security` | `environments/security/terraform.tfstate` |
| `environments/dev` | `environments/dev/terraform.tfstate` |
| `environments/test` | `environments/test/terraform.tfstate` |
| `environments/prod` | `environments/prod/terraform.tfstate` |

## Security Requirements

- Use the KMS key created by `bootstrap/remote-state`.
- Keep DynamoDB locking enabled.
- Keep state bucket versioning enabled.
- Do not commit `backend.hcl`, `*.tfvars`, `.terraform/`, `*.tfstate`, or plan files.
- Restrict backend access to CI roles and platform administrators.
