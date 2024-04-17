module "rosa-hcp_idp" {
  source  = "terraform-redhat/rosa-hcp/rhcs//modules/idp"
  version = "1.6.1-prerelease.1"

  cluster_id = module.rosa-hcp_rosa-cluster-hcp.cluster_id
  idp_type   = "htpasswd"
  name       = "admin"

  htpasswd_idp_users = [{
    username = var.admin_username
    password = var.admin_password
  }]
}
