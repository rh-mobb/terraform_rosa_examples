module "rosa-hcp_vpc" {
  source                   = "terraform-redhat/rosa-hcp/rhcs//modules/vpc"
  version                  = "1.6.1-prerelease.1"
  availability_zones_count = length(local.region_azs)
  name_prefix              = local.cluster_name
  tags                     = var.additional_tags
}
