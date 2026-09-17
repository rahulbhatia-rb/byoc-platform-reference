# Operating model

## Ownership boundaries

| Concern | Customer | Platform team |
| --- | --- | --- |
| Cloud account and billing | Owns account, billing and approved regions | Documents minimum permissions and capacity requirements |
| Network boundary | Approves CIDRs, connectivity and egress policy | Provisions versioned private network modules |
| Platform release | Approves change windows | Builds, signs, tests and promotes artifacts |
| Runtime operations | Receives service and incident updates | Owns SLOs, on-call response and remediation |
| Application data | Defines retention and residency requirements | Implements encryption, backups, restore tests and access controls |

## Provisioning lifecycle

1. Capture account ID, region, CIDR, identity role, data residency, and support contacts in a reviewed tenant record.
2. Run policy checks and a Terraform plan with the release version pinned.
3. Provision the network and private control plane.
4. Bootstrap GitOps, workload identity, telemetry, and approved workloads.
5. Run readiness checks: private endpoint reachability, metric labels, alert delivery, and backup success.
6. Publish the tenant's desired/observed platform version and handover evidence.

## Upgrade lifecycle

Deploy in cohorts, beginning with an internal or explicitly designated canary. Each upgrade has a compatibility check, an approved maintenance window where needed, and a rollback artifact. A successful infrastructure apply alone is insufficient: promotion requires application health, key SLO signals, telemetry, and customer-visible integration checks.

## SLO proposal

| Indicator | Initial objective | Why it matters |
| --- | --- | --- |
| Tenant provisioning success | 99% per calendar month | Signals whether BYOC is genuinely productized |
| Platform API availability | Define per customer tier | Provides a customer-facing reliability promise |
| Upgrade completion | 99% without rollback | Measures safe change delivery |
| Restore drill success | 100% of scheduled drills | Demonstrates recoverability, not just backups |

Objectives should be agreed with product and customers before becoming contractual. Error budgets should drive rollout velocity and engineering priorities.

## Incident discipline

The incident commander owns decisions and timeline; the communications owner provides predictable updates. Preserve logs, configuration version, and deployment evidence. A blameless review identifies contributing conditions, customer impact, and a small set of owners with due dates. Repeat incidents should be treated as a product backlog signal.
