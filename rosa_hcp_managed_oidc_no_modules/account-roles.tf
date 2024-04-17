module "rosa-hcp_account-iam-resources" {
  source               = "terraform-redhat/rosa-hcp/rhcs//modules/account-iam-resources"
  version              = "1.6.1-prerelease.1"
  account_role_prefix  = "${local.cluster_name}"
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  tags                 = var.additional_tags
}
