output "rosa_cluster" {
  value = { cluster = [
    {
      rosa_sts_cluster = module.rosa_cluster
    },
    {
      cluster_id = module.rosa_cluster.cluster_id
    } /*,
    {
      operator_iam_roles    = module.operator_roles_and_oidc.operator_iam_roles
    }*/
  ] }
}

##
output "oidc_config_id" {
  value = module.oidc_provider.id
}

output "oidc_endpoint_url" {
  value = module.oidc_provider.oidc_endpoint_url
}

output "thumbprint" {
  value = module.oidc_provider.thumbprint
}

output admin_username {
  value = module.rosa_cluster.admin_username
}

output admin_password {
  value = module.rosa_cluster.admin_password
  sensitive = true
}

output api_url {
  value = module.rosa_cluster.api_url
}
