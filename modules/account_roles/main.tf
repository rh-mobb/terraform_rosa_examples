#
# Copyright (c) 2022 Red Hat, Inc.
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

module "create_account_roles"{
  source = "terraform-redhat/rosa-sts/aws"
  version = "0.0.3"
  count = var.create_account_roles ? 1 : 0

  create_operator_roles = false
  create_oidc_provider = false
  create_account_roles = true

  account_role_prefix =  var.account_role_prefix
  ocm_environment =  var.ocm_environment
  rosa_openshift_version=  var.openshift_version
}