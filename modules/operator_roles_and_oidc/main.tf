data "ocm_rosa_operator_roles" "operator_roles" {
  account_role_prefix = var.account_role_prefix
  operator_role_prefix = var.operator_role_prefix
}

module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.3"
    
    create_operator_roles = true
    create_oidc_provider = true
    create_account_roles = false
    
    cluster_id = var.cluster_id
    rh_oidc_provider_thumbprint = var.oidc_thumbprint
    rh_oidc_provider_url = var.oidc_endpoint_url

    operator_roles_properties = data.ocm_rosa_operator_roles.operator_roles.operator_iam_roles
}