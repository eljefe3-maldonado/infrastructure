# Known Limitations

- No AWS-backed `terraform plan` has been run from this workspace.
- Real account IDs, organization IDs, backend names, and delegated administrator IDs are placeholders in examples.
- SCPs are examples and must be tested in a sandbox OU before broad attachment.
- KMS service-principal grants are functional but broad; a future hardening pass should add `kms:ViaService`, `aws:SourceAccount`, and `aws:SourceArn` constraints where supported.
- `test` and `prod` environment roots are placeholders.
- Inspector and Macie directories exist but are not implemented.
- IAM Identity Center and permission sets are not implemented.
- Organization account creation, OU management, and account baseline modules are not implemented.
- VPC endpoints and DNS modules are not implemented.
- EC2, RDS, Lambda, EKS, and AI/ML workload baselines are not implemented.
- CI plan comments depend on `secrets.AWS_ROLE_ARN`; without that secret, plan runs are skipped.
- CI uses `terraform init -backend=false`; live backend initialization is an operator responsibility.
- OPA policy checks are non-blocking.
