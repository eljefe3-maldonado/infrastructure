# Architecture Overview

The baseline is organized by AWS foundation domain: bootstrap, organization, security, identity, logging, network, workload baselines, environments, and policy-as-code.

Environment roots compose reusable modules. Modules avoid hardcoded account IDs, ARNs, regions, and names. Live values should come from backend configuration, `tfvars` files kept outside source control, CI variables, or a secrets manager.

## Design Goals

- Keep reusable modules account-agnostic.
- Separate bootstrap, log archive, security, and workload environments.
- Make secure defaults the easiest path.
- Keep live account wiring out of source control.
- Support future multi-account expansion into security, log archive, shared services, dev, test, and prod accounts.

## Implemented Domains

| Domain | Current implementation |
| --- | --- |
| Bootstrap | `bootstrap/remote-state` creates S3 state storage, DynamoDB locking, and KMS encryption. |
| Logging | `logging/kms-keys` and `logging/log-archive-buckets` provide encrypted centralized log storage. |
| Security | CloudTrail, Config, GuardDuty, Security Hub, and Access Analyzer modules are present. |
| Identity | `identity/break-glass` creates an MFA-gated administrator break-glass role. |
| Organization | `org/scps` creates reusable Service Control Policies. |
| Network | `network/vpc-baseline` and `network/vpc-flow-logs` create VPC foundations and flow log delivery. |
| Workloads | `workload-baselines/s3` creates secure general-purpose S3 buckets. |
| CI and policy | GitHub Actions, Checkov, tfsec config, and OPA policies are present. |

## Environment Model

| Environment | Status | Purpose |
| --- | --- | --- |
| `bootstrap/remote-state` | Implemented | One-time state backend bootstrap. |
| `environments/log-archive` | Implemented | Centralized log bucket and KMS key. |
| `environments/security` | Implemented | Organization CloudTrail, GuardDuty, Security Hub, and Access Analyzer. |
| `environments/dev` | Implemented | Development VPC and VPC Flow Logs. |
| `environments/test` | Placeholder | Future test workload baseline. |
| `environments/prod` | Placeholder | Future production workload baseline. |

## Security Boundaries

The log archive environment should run in a dedicated log archive account. Security tooling should run in a dedicated security account. Workload environments should use separate AWS accounts where possible.

Cross-account delivery is intentionally controlled by variables such as `org_id`, `delivery_source_account_ids`, bucket names, KMS ARNs, and delegated administrator account IDs. Do not hardcode these values in modules.

## Data Flow

1. Remote state is stored in an encrypted S3 bucket with DynamoDB locking.
2. Organization and workload services deliver logs to the log archive bucket.
3. Security services run from the security environment and rely on delegated administrator configuration where applicable.
4. Workload environments deploy networking and workload baselines while sending telemetry to centralized logging.
