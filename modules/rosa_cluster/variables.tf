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

variable rosa_openshift_version {
    type = string
    default = "openshift-v4.11.35"
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
##
variable "worker_node_replicas" {
  default     = null
  description = "Number of worker nodes to provision. Single zone clusters need at least 2 nodes, multizone clusters need at least 3 nodes"
  type        = number
}

variable "proxy" {
  default = null
  description = "cluster-wide HTTP or HTTPS proxy settings"
  type = object({
    http_proxy = string # required  http proxy
    https_proxy = string # required  https proxy
    additional_trust_bundle = optional(string) # a string contains contains a PEM-encoded X.509 certificate bundle that will be added to the nodes' trusted certificate store.
    no_proxy = optional(string) # no proxy
  })
}
variable "additional_tags" {
  default     = {}
  description = "Additional resource tags for ROSA CLuster"
  type        = map(string)
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

