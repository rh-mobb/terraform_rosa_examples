data "rhcs_policies" "all_policies" {}

data "rhcs_versions" "all" {}

module "create_account_roles" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.15"

  create_account_roles  = true
  create_operator_roles = false

  account_role_prefix    = local.cluster_name
  path                   = var.path
  rosa_openshift_version = regex("^[0-9]+\\.[0-9]+", var.rosa_openshift_version)
  account_role_policies  = data.rhcs_policies.all_policies.account_role_policies
  all_versions           = data.rhcs_versions.all
  operator_role_policies = data.rhcs_policies.all_policies.operator_role_policies
  tags                   = var.additional_tags
}

# This is unfortunately needed as the cluster will try to build before the account role
# is created. Hopefully this is fixed in the future
resource "time_sleep" "wait_10_seconds" {
  depends_on = [module.create_account_roles]

  create_duration = "10s"
}
