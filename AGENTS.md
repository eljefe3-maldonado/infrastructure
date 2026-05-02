# AGENTS.md

This file extends [SHARED_AGENT_CONTEXT.md](/home/grasshopper/Projects/SHARED_AGENT_CONTEXT.md).
Project-specific rules below override the shared context where they conflict.

## Project Overview

`infrastructure` is the Terraform-focused AWS infrastructure project in this workspace.
The directory was migrated from the previous misspelled `infrastrcuture` path after
explicit user approval.

## Working Scope

- Stay inside [`/home/grasshopper/Projects/infrastructure`](/home/grasshopper/Projects/infrastructure).
- Inspect the local file layout before adding new Terraform files or modules.
- Prefer extending existing modules and variable patterns over introducing parallel
  structures.
- Assume infrastructure changes may affect cost, IAM scope, or availability until proven
  otherwise.

## Safe Default Commands

Use the narrowest Terraform validation that matches the change:

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

If the project later gains subdirectories or modules with separate roots, run commands in
the affected root only.

## Commands Requiring Explicit User Confirmation

Do not run these without approval:

```bash
terraform apply
terraform destroy
```

Also require confirmation before changing remote state settings, backend files, or any
live account wiring.

## Project-Specific Rules

- Use `snake_case` consistently for Terraform identifiers.
- Keep variables, outputs, and resource naming aligned with existing files in this
  project.
- Do not create placeholder examples or template directories unless the user asked for
  scaffolding.
- Treat `*.tfvars`, `*.auto.tfvars`, `backend.hcl`, and `terraform.tfstate*` as sensitive.

## Out Of Scope By Default

- renaming the top-level project directory again
- changing remote state configuration
- broad IAM expansion or organization-wide policy changes without explicit direction
