locals {
  name = "byoc-${var.customer_id}"
  tags = {
    customer_id      = var.customer_id
    environment      = "production"
    platform_version = var.platform_version
    owner            = "platform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "../../modules/network"

  name               = local.name
  cidr_block         = "10.42.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  tags               = local.tags
}

module "eks" {
  source = "../../modules/eks"

  name               = local.name
  private_subnet_ids = module.network.private_subnet_ids
  tags               = local.tags
}

module "observability" {
  source = "../../modules/observability"
}
