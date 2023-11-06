#Common variables
variable "redhat_aws_account_id" {
  type    = string
  default = "710019948333"
}

variable "rosa_openshift_version" {
  type        = string
  default     = "4.13"
  description = "Desired version of OpenShift for the cluster, for example '4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
}

# Account Roles
variable "account_role_prefix" {
  type    = string
  default = "mobb"
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

# Used ?
variable "rh_oidc_provider_thumbprint" {
  description = "Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com"
  type        = string
  default     = "917e732d330f9a12404f73d8bea36948b929dffc"
}

variable "all_versions" {
  description = "OpenShift versions"
  type = object({
    item = object({
      id   = string
      name = string
    })
    search = string
    order  = string
    items = list(object({
      id   = string
      name = string
    }))
  })
  default = null
}

# Operrator Roles
variable "operator_role_prefix" {
  type    = string
  default = "mobbtf"
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
  default     = false
}

variable "create_operator_roles" {
  type        = bool
  description = "Create cluster wide operator roles"
  default     = false
}

variable "create_vpc" {
  type        = bool
  description = "Create custom VPC for ROSA cluster"
  default     = false
}

variable "managed_oidc" {
  type        = bool
  description = "Red Hat managed or unmanaged (Customer hosted) OIDC Configuration"
  default     = true
}

variable "create_aad_app" {
  type        = bool
  description = "Create a Azure AD app for ROSA cluster idp"
  default     = false
}

variable "create_idp_aad" {
  type        = bool
  description = "Create Azure AD IDP for ROSA cluster"
  default     = false
}

# ROSA Cluster info
variable "cluster_name" {
  type        = string
  description = "The name of the ROSA cluster to create"
  default     = "mobb-tf"

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,13}[a-z0-9]$", var.cluster_name))
    error_message = "ROSA cluster name must be less than 16 characters, be lower case alphanumeric, with only hyphens."
  }
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
  default     = false
}

variable "machine_type" {
  description = "The AWS instance type that used for the instances creation ."
  type        = string
}

variable "worker_node_replicas" {
  default     = null
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
  default     = null
}

variable "max_replicas" {
  description = "The maximum number of replicas not exceeded by the autoscaling functionality."
  type        = number
  default     = null
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
variable "enable_private_link" {
  type        = bool
  description = "This enables private link"
  default     = false
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
  default = "us-east-2"
}

variable "availability_zones" {
  type        = list(any)
  description = "The availability zones to use for the cluster"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

#Azure AD config
variable "aad_app_name" {
  type        = string
  default     = "kumudu-tf-test-app"
  description = "Azure AD App Name"
}

variable "aad_app_password_name" {
  type        = string
  default     = "kh-ROSA-Secret"
  description = "AAD Secret Name"
}

variable "aad_app_redirect_uri" {
  type        = string
  default     = "https://oauth-openshift.apps.iv2wbc7f.westus2.aroapp.io/oauth2callback/AAD"
  description = "AAD App Redirect_uri"
}

variable "aad_location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

#IDP
variable "idp_name" {
  type    = string
  default = "AAD"
}

variable "aad_client_id" {
  description = "Azure Application (client) ID"
  default     = "known"
  type        = string
}

variable "aad_client_secret" {
  description = "Azure Client credentials"
  default     = "known"
  type        = string
  sensitive   = true
}

variable "aad_tenant_id" {
  description = "Azure Directory (tenant) ID"
  type        = string
  sensitive   = true
}
