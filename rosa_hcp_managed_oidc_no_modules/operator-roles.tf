module "rosa-hcp_operator-roles" {
  source               = "terraform-redhat/rosa-hcp/rhcs//modules/operator-roles"
  version              = "1.6.1-prerelease.1"
  oidc_endpoint_url    = module.rosa-hcp_oidc-config-and-provider.oidc_endpoint_url
  operator_role_prefix = "${local.cluster_name}-ROSA"
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  tags                 = var.additional_tags
}
