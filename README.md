# BYOC Platform Reference

> An implementation-oriented reference for operating a developer platform in a customer's AWS account - repeatably, securely, and without turning every enterprise deployment into bespoke work.

## Why this project

Nango's platform has to work both as a fast-moving developer product and inside customer-controlled cloud environments. That is a systems problem: every tenant needs an opinionated baseline, a safe upgrade path, observable operations, and clear ownership boundaries.

This repository is my practical answer. It turns a BYOC deployment into a versioned product contract rather than a one-off infrastructure engagement.

I am Rahul H Bhatia, a platform engineer with production AWS/GCP, Kubernetes, Terraform, GitOps, identity, and observability experience. Highlights include reusable Terraform modules that reduced service onboarding to under two hours, OIDC/workload identity adoption, private-by-default network designs, EKS cost optimization, and on-call ownership. See my [LinkedIn](https://www.linkedin.com/in/rahul-h-bhatia/), [portfolio](https://rahulhbhatia.vercel.app), and [Credly badges](https://www.credly.com/users/rahul-h-bhatia/badges).

## What this demonstrates

| Nango platform need | Implementation in this reference |
| --- | --- |
| Productized BYOC | A small, versioned input contract: `customer_id`, `platform_version`, region, and a controlled network CIDR. |
| Customer-cloud security | The tenant owns its AWS account; workloads run in private subnets and the EKS API is private-only. |
| Reusable IaC | Composable network, EKS, and observability modules with explicit outputs and tags. |
| Operable upgrades | Every resource carries `customer_id`, `environment`, and `platform_version`; canary and rollback procedures are documented. |
| Reliability as a feature | A Prometheus/OpenMetrics label contract plus proposed provisioning, availability, and upgrade SLOs. |
| Enterprise posture | Least privilege, short-lived identity, auditability, backups, and incident evidence are defined as operating controls. |

## Architecture

```text
Customer AWS account
└── dedicated VPC
    ├── two private workload subnets
    ├── private EKS control-plane endpoint
    ├── versioned platform workload (GitOps-managed in production)
    └── observability namespace
        └── Prometheus/OpenMetrics
            labels: customer_id, environment, platform_version
```

This first reference keeps the infrastructure surface focused. A production release would add managed Postgres, Redis, search/analytics stores where required, encryption keys, backups, retention policies, and tenant-specific sizing through separately versioned modules. The important design rule is that the application contract stays stable while those components evolve independently.

## Repository map

```text
modules/network/          Private VPC and multi-AZ workload subnets
modules/eks/              Private EKS control plane and IAM boundary
modules/observability/    Metrics contract shared by every tenant
examples/aws-byoc/        The consumable tenant deployment
docs/operating-model.md   Provisioning, upgrades, incidents, and SLOs
docs/security-controls.md Control objectives for enterprise reviews
```

## Implement a tenant

### 1. Establish the account boundary

The customer creates a dedicated AWS account or grants a narrowly scoped deployment role. CI assumes that role using OIDC; no long-lived cloud keys are stored in the repository.

### 2. Pin a platform release

The deployment interface is intentionally small:

```bash
cd examples/aws-byoc
terraform init
terraform plan \
  -var='customer_id=acme' \
  -var='platform_version=0.1.0' \
  -var='aws_region=eu-west-1'
```

Run the plan through reviewed CI. Apply only from the protected deployment workflow after a customer-approved change window.

### 3. Bootstrap workloads and observability

After Terraform provisions the private control plane, a GitOps controller installs the pinned application release and telemetry collectors. Every metric must carry the three labels returned by the `observability` module, enabling per-tenant alert routing and upgrade analysis.

### 4. Upgrade safely

1. Release a versioned module/application artifact.
2. Run `terraform plan` against a canary tenant and attach it to the change record.
3. Verify provisioning, availability, and error-budget indicators after rollout.
4. Promote in cohorts; retain the prior artifact and documented rollback procedure.
5. Record the final `platform_version` tag and deployment evidence.

## Operational standards

The detailed operating model is in [docs/operating-model.md](docs/operating-model.md). The short version:

- Provisioning success: 99% of tenant deployments complete without manual infrastructure intervention.
- Availability: define and publish service-specific SLOs; page only on burn-rate signals that require action.
- Upgrades: measure duration, failures, and rollback rate per platform version.
- Incidents: one incident commander, one customer communication owner, timestamps, a customer-safe summary, and follow-up actions tracked to closure.
- Drift: detect it automatically; resolve through Terraform or GitOps, never undocumented console edits.

## Local verification

```bash
terraform fmt -check -recursive
cd examples/aws-byoc
terraform init -backend=false
terraform validate
```

The example validates with Terraform 1.5.7 and the AWS provider lock file committed in this repository. `.github/workflows/terraform.yml` repeats formatting and validation for pull requests.

## What I would build next

1. A signed platform-release manifest and upgrade controller that validates compatibility before deployment.
2. Dedicated data-layer modules with backup/restore drills, replicas, maintenance windows, and capacity signals.
3. GitOps bootstrap with workload identity and per-tenant policy bundles.
4. A tenant operations API showing desired version, observed version, drift, SLO health, and upgrade history.

Those are the seams where an internal infrastructure practice becomes a product customers trust.
