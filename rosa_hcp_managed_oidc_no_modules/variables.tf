variable "openshift_version" {
  type        = string
  default     = "4.14.20"
  description = "Desired version of OpenShift for the cluster, for example '4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
}

# ROSA Cluster info
variable "cluster_name" {
  default     = null
  type        = string
  description = "The name of the ROSA cluster to create"
}

variable "multi_az" {
  type        = bool
  description = "Multi AZ Cluster for High Availability"
  default     = true
}

variable "additional_tags" {
  default = {
    Terraform   = "true"
    Environment = "dev"
    TFOwner     = "mobb@redhat.com"
  }
  description = "Additional AWS resource tags"
  type        = map(string)
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}

variable "machine_type" {
  description = "The AWS instance type used for your default worker pool"
  type        = string
  default     = "m5.xlarge"
}

variable "worker_node_replicas" {
  default     = 3
  description = "Number of worker nodes to provision. Single zone clusters need at least 2 nodes, multizone clusters need at least 3 nodes"
  type        = number
}


variable "autoscaling_enabled" {
  description = "Enables autoscaling. This variable requires you to set a maximum and minimum replicas range using the `max_replicas` and `min_replicas` variables."
  type        = string
  default     = "false"
}

variable "min_replicas" {
  description = "The minimum number of replicas for autoscaling."
  type        = number
  default     = 3
}

variable "max_replicas" {
  description = "The maximum number of replicas not exceeded by the autoscaling functionality."
  type        = number
  default     = 3
}

variable "http_proxy" {
  default     = null
  description = "A proxy URL to use for creating HTTP connections outside the cluster. The URL scheme must be http."
  type        = string
}

variable "https_proxy" {
  default     = null
  description = "A proxy URL to use for creating HTTPS connections outside the cluster."
  type        = string
}

variable "no_proxy" {
  default     = null
  description = "A comma-separated list of destination domain names, domains, IP addresses or other network CIDRs to exclude proxying."
  type        = string
}

variable "additional_trust_bundle" {
  type        = string
  description = "A string containing a PEM-encoded X.509 certificate bundle that will be added to the nodes' trusted certificate store."
  default     = null
}

variable "private_cluster" {
  type        = bool
  description = "Do you want this cluster to be private? true or false"
}

#VPC Info
variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "mobb-tf-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "value of the CIDR block to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(any)
  description = "The CIDR blocks to use for the private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  type        = list(any)
  description = "The CIDR blocks to use for the public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single NAT or per NAT for subnet"
  default     = false
}

#AWS Info
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "private_subnet_ids" {
  type        = list(any)
  description = "VPC private subnets IDs for ROSA Cluster"
  default     = []
}

variable "admin_username" {
  type        = string
  description = "The username for the admin user"
}

variable "admin_password" {
  type        = string
  description = "The password for the admin user"
  sensitive   = true
}

variable "default_aws_tags" {
  type        = map(string)
  description = "Default tags for AWS"
  default     = {}
}

variable "permissions_boundary" {
  type    = string
  default = ""
}
