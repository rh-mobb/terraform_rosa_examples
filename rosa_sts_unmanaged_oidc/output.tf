##
output "cluster_id" {
  value = module.rosa_cluster.cluster_id
}

output "oidc_config_id" {
  value = module.oidc_provider.id
}

output "oidc_endpoint_url" {
  value = module.oidc_provider.oidc_endpoint_url
}

output "thumbprint" {
  value = module.oidc_provider.thumbprint
}

output "admin_username" {
  value = module.rosa_cluster.admin_username
}

output "admin_password" {
  value     = module.rosa_cluster.admin_password
  sensitive = true
}

output "api_url" {
  value = module.rosa_cluster.api_url
}

output "domain" {
  value = module.rosa_cluster.domain
}
