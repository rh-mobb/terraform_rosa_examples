module "rosa-hcp_rosa-cluster-hcp" {
  source  = "terraform-redhat/rosa-hcp/rhcs//modules/rosa-cluster-hcp"
  version = "1.6.1-prerelease.1"

  # Required settings
  cluster_name         = local.cluster_name
  oidc_config_id       = module.rosa-hcp_oidc-config-and-provider.oidc_config_id
  openshift_version    = var.openshift_version
  operator_role_prefix = "${local.cluster_name}-ROSA"

  aws_subnet_ids = var.private_cluster ? var.private_subnet_ids : concat(module.rosa-hcp_vpc.private_subnets, module.rosa-hcp_vpc.public_subnets)

  # Optional settings
  account_role_prefix = "${local.cluster_name}-HCP-ROSA"
  private             = var.private_cluster

  aws_availability_zones = local.region_azs

  # Wait for control plane availability
  wait_for_create_complete = true

  # Wait for initial Machine Pool availability
  wait_for_std_compute_nodes_complete = true

  compute_machine_type       = var.machine_type
  cluster_autoscaler_enabled = var.autoscaling_enabled
  path                       = var.path
  tags                       = var.additional_tags

  # Note, this is the replica count of the default machine pool. Additional pools should be managed with the worker_pool module
  replicas = local.worker_node_replicas

  # Proxy settings
  http_proxy              = var.http_proxy
  https_proxy             = var.https_proxy
  no_proxy                = var.no_proxy
  additional_trust_bundle = var.additional_trust_bundle

  # Temp
  default_ingress_listening_method = "external"
}
