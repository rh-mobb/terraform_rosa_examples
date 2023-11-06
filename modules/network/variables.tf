variable "create_vpc" {
  type        = bool
  description = "Create custom VPC for ROSA cluster"
  default     = false
}

variable "aws_region" {
  type        = string
  description = "The region to create the ROSA cluster in"
  default     = "us-east-2"
}

variable "vpc_name" {
  type = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "vpc_cidr_block" {
  type        = string
  description = "value of the CIDR block to use for the VPC"
  default     = "10.66.0.0/16"
}

variable "availability_zones" {
  type        = list(any)
  description = "The availability zones to use for the cluster"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "private_subnet_cidrs" {
  type        = list(any)
  description = "The CIDR blocks to use for the private subnets"
  default     = ["10.66.1.0/24", "10.66.2.0/24", "10.66.3.0/24"]
}

variable "public_subnet_cidrs" {
  type        = list(any)
  description = "The CIDR blocks to use for the public subnets"
  default     = ["10.66.101.0/24", "10.66.102.0/24", "10.66.103.0/24"]
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single NAT or per NAT for subnet"
  default     = false
}
