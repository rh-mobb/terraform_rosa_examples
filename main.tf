
module account_role {
    source = "./modules/account_roles"
    ocm_environment = var.ocm_environment    
    openshift_version = var.rosa_openshift_version
    account_role_prefix = var.account_role_prefix
} 


module "byo_vpc" {
    #count = var.create_vpc ? 1 : 0
    create_vpc = var.create_vpc
    source = "./modules/network"
    aws_region = var.aws_region
    vpc_name = var.vpc_name
    additional_tags = var.additional_tags
    vpc_cidr_block = var.vpc_cidr_block
    availability_zones = var.availability_zones
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs = var.public_subnet_cidrs
}
#TODO switch to mobb VPC module
/*
module openshift_vpc {
    source = "rh-mobb/rosa-privatelink-vpc/aws"
    name = "my_rosa_vpc"
    region = "us-east-2"
    azs  = ["us-east-2a", "us-east-2b", "us-east-2c"]    
    cidr = "10.0.0.0/22"
    private_subnets_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    transit_gateway = {
        peer = true
        transit_gateway_id = "tgw-xxx"
        dest_cidrs = ["192.168.0.0/24, "192.168.1.0/24"]
    }
}
*/

module "rosa_cluster" {
    source = "./modules/rosa_cluster"
    cluster_name = var.cluster_name
    token = var.token
    url = var.url
    aws_region = var.aws_region
    multi_az = var.multi_az
    availability_zones =  var.availability_zones   
    account_role_prefix = var.account_role_prefix
    operator_role_prefix = var.operator_role_prefix
    #private link cluster values
    enable_private_link = var.enable_private_link
    private_subnet_ids = var.enable_private_link ? module.byo_vpc.private_subnets : []
    vpc_cidr_block = var.enable_private_link ? var.vpc_cidr_block : null
} 

locals {
  cluster_id = module.rosa_cluster.cluster_id
  oidc_thumbprint = module.rosa_cluster.oidc_thumbprint
  oidc_endpoint_url = module.rosa_cluster.oidc_endpoint_url
  #cluster_dns_name = module.rosa_cluster.cluster_dns
  cluster_dns_name = "change_me"
}

#TODO test locals
module operator_roles_and_oidc {
    source = "./modules/operator_roles_and_oidc"
    token = var.token
    account_role_prefix = var.account_role_prefix
    operator_role_prefix = var.operator_role_prefix
    cluster_id = module.rosa_cluster.cluster_id
    oidc_thumbprint = module.rosa_cluster.oidc_thumbprint
    oidc_endpoint_url = module.rosa_cluster.oidc_endpoint_url  
}

module aad_application{
    source = "./modules/AAD_application"
    create_aad_app = var.create_aad_app
    aad_app_name = var.aad_app_name
    aad_app_password_name = var.aad_app_password_name
    aad_app_redirect_uri = "https://oauth-openshift.apps.${local.cluster_dns_name}/oauth2callback/${var.idp_name}"
    location = var.aad_location
}
/*
module aad_idp{
    count = var.create_idp_aad ? 1 : 0
    source = "./modules/idp_AAD"    
    token = var.token
    url = var.url
    cluster_name = var.cluster_name
    aad_client_id = module.AAD_application.application_id
    aad_client_secret = module.AAD_application.secret_value
    aad_tenant_id = var.aad_tenant_id
}*/