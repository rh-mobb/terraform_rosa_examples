#OCM settings
variable token {
  type = string
  sensitive = true
}

variable url {
    type = string
    default = "https://api.openshift.com"
}

#AWS settings
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type        = list(any)
  description = "The availability zones to use for the cluster"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

#Cluster settings
variable "cluster_name" {
    type = string
    default = "kumudu-tf-01"
}

variable account_role_prefix {
    type = string
    default = "kumudu"
}

variable operator_role_prefix {
    type = string
    default = "mobbkh"
}

variable multi_az {
    type = bool
    description = "Multi AZ Cluster for High Availability"
    default = false
}

variable "vpc_cidr_block" {
  type        = string
  description = "value of the CIDR block to use for the VPC"
  default     = "10.0.0.0/16"
}


#Private Link
variable "enable_private_link" {
  type        = bool
  description = "This enables private link"
  default     = false
}

variable "private_subnet_ids" {
  type        = list(any)
  description = "VPC private subnets IDs for ROSA Cluster"
  default = []
}

