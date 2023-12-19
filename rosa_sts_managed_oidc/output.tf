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
  sensitive = true
}

output "cluster_id" {
  value = module.rosa_cluster.cluster_id
}

output "domain" {
  value = module.rosa_cluster.domain
}
