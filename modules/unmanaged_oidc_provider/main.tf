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

# Generates the OIDC config resources' names
resource "rhcs_rosa_oidc_config_input" "oidc_input" {
  region = var.aws_region
}

# Create the OIDC config resources on AWS
module "oidc_config_input_resources" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.15"

  create_oidc_config_resources = true

  bucket_name             = one(rhcs_rosa_oidc_config_input.oidc_input[*].bucket_name)
  discovery_doc           = one(rhcs_rosa_oidc_config_input.oidc_input[*].discovery_doc)
  jwks                    = one(rhcs_rosa_oidc_config_input.oidc_input[*].jwks)
  private_key             = one(rhcs_rosa_oidc_config_input.oidc_input[*].private_key)
  private_key_file_name   = one(rhcs_rosa_oidc_config_input.oidc_input[*].private_key_file_name)
  private_key_secret_name = one(rhcs_rosa_oidc_config_input.oidc_input[*].private_key_secret_name)

  tags                        = var.additional_tags
  path                        = var.path
}

resource "rhcs_rosa_oidc_config" "oidc_config" {
  managed            = false
  secret_arn         = one(module.oidc_config_input_resources[*].secret_arn)
  issuer_url         = one(rhcs_rosa_oidc_config_input.oidc_input[*].issuer_url)
  installer_role_arn = var.installer_role_arn
}

# Create the unmanaged OIDC provider
module "operator_roles_and_oidc_provider" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.15"

  create_oidc_provider  = true

  cluster_id                  = ""
  rh_oidc_provider_thumbprint = rhcs_rosa_oidc_config.oidc_config.thumbprint
  rh_oidc_provider_url        = rhcs_rosa_oidc_config.oidc_config.oidc_endpoint_url
  tags                        = var.additional_tags
  path                        = var.path
}
