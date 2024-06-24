data "aws_availability_zones" "available" {}

locals {
  # Extract availability zone names for the specified region, limit it to 3
  region_azs = slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 3)
}

resource "random_string" "random_name" {
  length  = 6
  special = false
  upper   = false
}

locals {
  path                 = coalesce(var.path, "/")
  worker_node_replicas = try(var.worker_node_replicas, var.multi_az ? 3 : 2)
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  cluster_name = coalesce(var.cluster_name, "rosa-${random_string.random_name.result}")
}

# If we are making our own VPC, the network verifier can pop up very quickly, sometimes so quickly
# it results in warnings for end users which are not correct. This prevents this.
resource "time_sleep" "wait_60_seconds" {
  count = var.create_vpc ? 1 : 0
  depends_on = [module.vpc]
  create_duration = "60s"
}

module "rosa-classic" {
  source                 = "terraform-redhat/rosa-classic/rhcs"
  version                = "1.6.2-prerelease.1"
  cluster_name           = local.cluster_name
  openshift_version      = var.openshift_version
  account_role_prefix    = local.cluster_name
  operator_role_prefix   = local.cluster_name
  replicas               = local.worker_node_replicas
  aws_availability_zones = local.region_azs
  create_oidc            = true
  private                = var.private_cluster
  aws_private_link       = var.private_cluster
  aws_subnet_ids         = var.create_vpc ? var.private_cluster ? module.vpc[0].private_subnets : concat(module.vpc[0].public_subnets, module.vpc[0].private_subnets) : var.aws_subnet_ids
  multi_az               = var.multi_az
  create_account_roles   = true
  create_operator_roles  = true

  # Currently the network verifier can run a little too quickly, causing UX warnings. This prevents it
  depends_on = [time_sleep.wait_60_seconds]
}
