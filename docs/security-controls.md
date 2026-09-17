# Security controls for customer-cloud deployments

This is a practical control map for customer security reviews, not a claim of certification.

## Identity and access

- Use OIDC federation from CI to a customer-approved deployment role; do not store static AWS keys.
- Separate read-only, plan, apply, and break-glass permissions.
- Review privileged access and deployment-role trust policies on a defined cadence.

## Network and secrets

- Keep workloads and Kubernetes API endpoints private by default.
- Restrict egress deliberately and record required destinations.
- Store secrets in the customer-approved secret manager and rotate them; never expose them in Terraform output or CI logs.

## Data and recovery

- Classify data before selecting Postgres, Redis, Elasticsearch, or ClickHouse topology.
- Encrypt in transit and at rest with customer-approved keys where required.
- Set retention and deletion requirements per tenant; exercise restore procedures regularly.

## Evidence and change management

- Keep reviewed plans, deployment approvals, artifact versions, access logs, and incident records.
- Detect configuration drift and reconcile through code.
- Pair vulnerability remediation with severity-based response targets and evidence of closure.
