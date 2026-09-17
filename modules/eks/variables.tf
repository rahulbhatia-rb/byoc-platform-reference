variable "name" {
  type        = string
  description = "Cluster name."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets used by the control plane and nodes."
}

variable "kubernetes_version" {
  type        = string
  description = "Supported Kubernetes minor version."
  default     = "1.31"
}

variable "tags" {
  type        = map(string)
  description = "Tags shared by cluster resources."
  default     = {}
}
