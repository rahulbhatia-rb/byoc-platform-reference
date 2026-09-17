data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count = length(var.availability_zones)
  common_tags = merge(var.tags, {
    "managed-by" = "terraform"
    "module"     = "network"
  })
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, { Name = "${var.name}-vpc" })
}

resource "aws_subnet" "private" {
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.cidr_block, 4, index(var.availability_zones, each.value))

  tags = merge(local.common_tags, {
    Name                              = "${var.name}-private-${each.value}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}
