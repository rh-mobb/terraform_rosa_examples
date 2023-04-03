#TODO variabalized role name prefix ${var.account_role_prefix} , seems provider not accepting !! ${var.account_role_prefix}
locals {
  sts_roles = {
      role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Installer-Role",
      support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Support-Role",
      instance_iam_roles = {
        master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-ControlPlane-Role",
        worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Worker-Role"
      },
      operator_role_prefix = var.operator_role_prefix,
  }
}

# Declare the data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {
}


resource "ocm_cluster_rosa_classic" "rosa_sts_cluster" {
  name           = var.cluster_name
  cloud_region   = var.aws_region
  multi_az = var.multi_az
  aws_account_id     = data.aws_caller_identity.current.account_id
  #availability_zones = [data.aws_availability_zones.available.names[0]] #TODO: use var and if no var use dynamic
  availability_zones = var.availability_zones
  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }
  #ToDo set cluster version, enable-autoscaling, min-replicas max-replicas, service-cidr, pod-cidr, host prefix
  sts = local.sts_roles
  #Private link settings
  aws_private_link = var.enable_private_link
  aws_subnet_ids = var.private_subnet_ids
  #aws_subnet_ids = var.enable_private_link ? jsonencode(var.private_subnet_ids) : []
  #aws_subnet_ids = var.enable_private_link ? concat(var.private_subnet_ids) : []
  machine_cidr = var.enable_private_link ? var.vpc_cidr_block : null

}

/*resource "ocm_cluster_wait" "rosa_cluster" {
  cluster = ocm_cluster_rosa_classic.rosa_sts_cluster.id
  # timeout in minutes, i.e 60
  timeout = 10
}*/