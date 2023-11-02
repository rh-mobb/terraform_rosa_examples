#
# Copyright (c) 2023 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Create the VPC if it is wanted
module "vpc" {
  create_vpc           = var.create_vpc
  source               = "../modules/network"
  aws_region           = var.aws_region
  vpc_name             = var.vpc_name
  additional_tags      = var.additional_tags
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
}

# Create the main account roles for ROSA
module "account_role" {
  create_account_roles   = var.create_account_roles
  source                 = "../modules/account_roles"
  account_role_prefix    = var.account_role_prefix
  path                   = var.path
  ocm_environment        = var.ocm_environment
  rosa_openshift_version = var.rosa_openshift_version
  account_role_policies  = var.account_role_policies
  all_versions           = var.all_versions
  operator_role_policies = var.operator_role_policies
  additional_tags        = var.additional_tags
}

# This is unfortunately needed as the cluster will try to build before the account role
# is created. Hopefully this is fixed in the future
resource "time_sleep" "wait_10_seconds" {
  depends_on = [module.account_role]

  create_duration = "10s"
}

# Create managed OIDC config
module "oidc_provider" {
  source               = "../modules/managed_oidc_provider"
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix  = var.account_role_prefix
  additional_tags      = var.additional_tags
  path                 = var.path
  # We need the account role to be created before we can make the OIDC provider
  depends_on = [time_sleep.wait_10_seconds]
}

# Create the operator roles for ROSA
module "operator_roles" {
  create_operator_roles = var.create_operator_roles
  source               = "../modules/operator_roles"
  oidc_thumbprint       = module.oidc_provider.thumbprint
  oidc_endpoint_url     = module.oidc_provider.oidc_endpoint_url
  operator_role_prefix = var.operator_role_prefix
  additional_tags      = var.additional_tags
}

# Make the ROSA Cluster
module "rosa_cluster" {
  source                 = "../modules/rosa_cluster"
  cluster_name           = var.cluster_name
  rosa_openshift_version = var.rosa_openshift_version
  aws_region             = var.aws_region
  multi_az               = var.multi_az
  availability_zones     = var.availability_zones
  account_role_prefix    = var.account_role_prefix
  operator_role_prefix   = var.operator_role_prefix
  machine_type           = var.machine_type
  proxy                  = var.proxy
  autoscaling_enabled    = var.autoscaling_enabled
  min_replicas           = var.min_replicas
  max_replicas           = var.max_replicas
  oidc_config_id         = module.oidc_provider.id
  additional_tags        = var.additional_tags
  vpc_cidr_block         = var.vpc_cidr_block

  #private link cluster values
  enable_private_link = var.enable_private_link
  aws_subnet_ids   = var.create_vpc ? module.vpc.private_subnets : var.aws_subnet_ids

  depends_on = [time_sleep.wait_10_seconds]
}

