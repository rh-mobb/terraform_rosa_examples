data "aws_availability_zones" "available" {}

locals {
  # Extract availability zone names for the specified region, limit it to 1
  region_azs = slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 1)
}

resource "random_string" "random_name" {
  length           = 6
  special          = false
  upper            = false
}

locals {
  path = coalesce(var.path, "/")
  sts_roles = {
    role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.cluster_name}-Installer-Role",
    support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.cluster_name}-Support-Role",
    instance_iam_roles = {
      master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.cluster_name}-ControlPlane-Role",
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.cluster_name}-Worker-Role"
    },
    operator_role_prefix = local.cluster_name,
    oidc_config_id       = rhcs_rosa_oidc_config.oidc_config.id
  }
  worker_node_replicas = coalesce(var.worker_node_replicas, 2)
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  cluster_name = coalesce(var.cluster_name, "rosa-${random_string.random_name.result}")
}

data "aws_caller_identity" "current" {
}

resource "rhcs_cluster_rosa_classic" "rosa_sts_cluster" {
  name                 = local.cluster_name
  cloud_region         = var.aws_region
  multi_az             = false
  aws_account_id       = data.aws_caller_identity.current.account_id
  availability_zones   = local.region_azs
  tags                 = var.additional_tags
  version              = var.rosa_openshift_version
  compute_machine_type = var.machine_type
  replicas             = local.worker_node_replicas
  autoscaling_enabled  = false
  sts                  = local.sts_roles
  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }
  machine_cidr     = var.vpc_cidr_block

  lifecycle {
    precondition {
      condition     = can(regex("^[a-z][-a-z0-9]{0,13}[a-z0-9]$", local.cluster_name))
      error_message = "ROSA cluster name must be less than 16 characters, be lower case alphanumeric, with only hyphens."
    }
  }

  depends_on = [module.create_account_roles]
}

resource "rhcs_cluster_wait" "wait_for_cluster_build" {
  cluster = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  # timeout in minutes
  timeout = 60
}
