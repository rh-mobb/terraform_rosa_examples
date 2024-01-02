data "aws_availability_zones" "available" {}

resource "random_string" "random_name" {
  length           = 6
  special          = false
  upper            = false
}

locals {
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  cluster_name = coalesce(var.cluster_name, "rosa-${random_string.random_name.result}")
}

module "rosa_cluster" {
  source = "../rosa_sts_managed_oidc"
  create_vpc = true
  private_cluster = false
  admin_username = var.admin_username
  admin_password = var.admin_password
}
