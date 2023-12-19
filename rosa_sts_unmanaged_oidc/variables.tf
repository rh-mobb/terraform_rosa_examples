variable "rosa_openshift_version" {
  type        = string
  default     = "4.14.2"
  description = "Desired version of OpenShift for the cluster, for example '4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
}

variable "account_role_policies" {
  description = "account role policies details for account roles creation"
  type = object({
    sts_installer_permission_policy             = string
    sts_support_permission_policy               = string
    sts_instance_worker_permission_policy       = string
    sts_instance_controlplane_permission_policy = string
  })
  default = null
}

variable "operator_role_policies" {
  description = "operator role policies details for operator roles creation"
  type = object({
    openshift_cloud_credential_operator_cloud_credential_operator_iam_ro_creds_policy = string
    openshift_cloud_network_config_controller_cloud_credentials_policy                = string
    openshift_cluster_csi_drivers_ebs_cloud_credentials_policy                        = string
    openshift_image_registry_installer_cloud_credentials_policy                       = string
    openshift_ingress_operator_cloud_credentials_policy                               = string
    openshift_machine_api_aws_cloud_credentials_policy                                = string
  })
  default = null
}

# Module selection
variable "create_account_roles" {
  type        = bool
  description = "Create cluster wide accounts roles"
  default     = true
}

variable "create_operator_roles" {
  type        = bool
  description = "Create cluster wide operator roles"
  default     = true
}

variable "create_vpc" {
  type        = bool
  description = "Create custom VPC for ROSA cluster"
}

# ROSA Cluster info
variable "cluster_name" {
  type        = string
  description = "The name of the ROSA cluster to create"
  default     = null
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

variable "multi_az" {
  type        = bool
  description = "Multi AZ Cluster for High Availability"
  default     = true
}

variable "machine_type" {
  description = "The AWS instance type that used for the instances creation ."
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

variable "proxy" {
  default     = null
  description = "cluster-wide HTTP or HTTPS proxy settings"
  type = object({
    http_proxy              = string           # required  http proxy
    https_proxy             = string           # required  https proxy
    additional_trust_bundle = optional(string) # a string contains contains a PEM-encoded X.509 certificate bundle that will be added to the nodes' trusted certificate store.
    no_proxy                = optional(string) # no proxy
  })
}

#Private link cluster Info
variable "private_cluster" {
  type        = bool
  description = "Do you want this cluster to be private? true or false"
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

variable "aws_subnet_ids" {
  type = list(any)
  description = "A list of AWS Subnet IDs if you have created the VPC separately"
  default = null
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single NAT or per NAT for subnet"
  default     = false
}

#AWS Info
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "admin_username" {
  type = string
  description = "The username for the admin user"
}

variable "admin_password" {
  type = string
  description = "The password for the admin user"
  sensitive = true
}
