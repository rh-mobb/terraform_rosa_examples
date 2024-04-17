module "rosa-hcp_oidc-config-and-provider" {
  source  = "terraform-redhat/rosa-hcp/rhcs//modules/oidc-config-and-provider"
  version = "1.6.1-prerelease.1"
  managed = true
  tags    = var.additional_tags
}
