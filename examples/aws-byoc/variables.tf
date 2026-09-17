variable "aws_region" {
  type        = string
  description = "Customer-selected AWS region."
  default     = "us-east-1"
}

variable "customer_id" {
  type        = string
  description = "Stable tenant identifier used in names and tags."
}

variable "platform_version" {
  type        = string
  description = "Version of the platform release installed for this tenant."
}
