module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  count = var.create_vpc ? 1 : 0
  name  = var.vpc_name
  cidr  = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  #overwrite defualt naming
  #private_subnet_names = ["${var.vpc_name}-prv-subnet", "${var.vpc_name}-prv-subnet","${var.vpc_name}-prv-subnet"]
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.additional_tags
}

