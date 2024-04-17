data "aws_availability_zones" "available" {}

locals {
  # Extract availability zone names for the specified region, limit it to 3
  region_azs = slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, var.multi_az ? 3 : 1)
}

resource "random_string" "random_name" {
  length  = 6
  special = false
  upper   = false
}

locals {
  path = coalesce(var.path, "/")

  worker_node_replicas = try(var.worker_node_replicas, var.multi_az ? 3 : 2)
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  cluster_name = coalesce(var.cluster_name, "rosa-${random_string.random_name.result}")
}

data "aws_caller_identity" "current" {}
