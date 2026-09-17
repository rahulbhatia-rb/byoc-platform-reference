variable "namespace" {
  type        = string
  description = "Namespace reserved for platform observability."
  default     = "observability"
}

output "metrics_contract" {
  description = "The labels every tenant metric should include."
  value = {
    required_labels = ["customer_id", "environment", "platform_version"]
    scrape_protocol = "Prometheus/OpenMetrics"
    namespace       = var.namespace
  }
}
