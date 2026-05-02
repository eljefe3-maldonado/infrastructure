# CLAUDE.md - infrastructure

Extends `/home/grasshopper/Projects/SHARED_AGENT_CONTEXT.md`. Rules here override the shared context
where they conflict. Follow the shared context for everything not specified below.

---

## Project Overview

Production-grade AWS Terraform baseline for secure multi-account infrastructure.

---

## Stack

- **Type:** Terraform
- **AWS Region:** configurable, examples default to `us-east-1`
- **State Backend:** bootstrapped by `bootstrap/remote-state`

---

## Directory Layout

```
infrastructure/
  bootstrap/
  docs/
  environments/
  identity/
  logging/
  network/
  org/
  policies/
  security/
  workload-baselines/
```

---

## Commands

```bash
# Install / init
terraform init

# Validate & format
terraform validate
terraform fmt -recursive

# Plan / build / test
terraform plan -out=tfplan

# Apply (requires explicit user confirmation)
terraform apply tfplan
```

---

## Project-Specific Rules

- Only modify files inside this project directory.
- Keep account IDs, ARNs, regions, and backend names configurable.
- Do not commit real `*.tfvars`, backend files, state files, or secrets.

---

## Out of Scope

- Do not modify shared modules outside this project unless explicitly asked.
- Do not alter state backend config without user confirmation.
