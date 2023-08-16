output "rosa_cluster" {
  value = { cluster = [
    {
        rosa_sts_cluster  = module.rosa_cluster
    },
    {
        cluster_id    = module.rosa_cluster.cluster_id
    }/*,
    {
      operator_iam_roles    = module.operator_roles_and_oidc.operator_iam_roles
    }*/
  ]}
}

##
output "oidc_config_id" {
  value = module.byo_oidc_config.id
}

output "oidc_endpoint_url" {
  value = module.byo_oidc_config.oidc_endpoint_url
}

output "thumbprint" {
  value = module.byo_oidc_config.thumbprint
}
