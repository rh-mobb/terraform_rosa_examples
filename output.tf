output "rosa_cluster" {
  value = { cluster = [
    {
        public_cluster  = module.rosa_cluster
    },
    {
        cluster_id    = module.rosa_cluster.cluster_id
    },
    {
      operator_iam_roles    = module.operator_roles_and_oidc.operator_iam_roles
    }
  ]}
}