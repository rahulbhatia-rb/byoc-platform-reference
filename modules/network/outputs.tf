output "vpc_id" {
  value       = aws_vpc.this.id
  description = "Tenant VPC identifier."
}

output "private_subnet_ids" {
  value       = values(aws_subnet.private)[*].id
  description = "Private workload subnet identifiers."
}
