variable "name" {
  type        = string
  description = "A short, unique workload name used in resource names and tags."
}

variable "cidr_block" {
  type        = string
  description = "RFC 1918 CIDR block for the tenant VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "At least two availability zones used for private workload subnets."

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Use at least two availability zones for workload resilience."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags shared by all network resources."
  default     = {}
}
