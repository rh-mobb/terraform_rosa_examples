output "rosa_cluster" {
  value = { cluster = [
    {
      rosa_sts_cluster = module.rosa_cluster
    },
    {
      cluster_id = module.rosa_cluster.cluster_id
    }
  ] }
  sensitive = true
}

output "cluster_id" {
  value = module.rosa_cluster.cluster_id
}

output "domain" {
  value = module.rosa_cluster.domain
}

output "vpc_id" {
  value = var.create_vpc ? module.vpc.vpc_id : null
}
