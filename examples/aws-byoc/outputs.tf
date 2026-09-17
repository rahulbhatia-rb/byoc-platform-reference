output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Cluster name for the customer tenant."
}

output "metrics_contract" {
  value       = module.observability.metrics_contract
  description = "Labels and protocol required for tenant-level observability."
}
