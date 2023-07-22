#Common variables
variable redhat_aws_account_id {
    type = string
}

variable rosa_openshift_version {
    type = string
    default = "4.12"
}

variable token {
  type = string
  sensitive = true
}

variable url {
    type = string
    default = "https://api.openshift.com"
}

variable ocm_environment {
    type = string
    default = "production"
}

variable account_role_prefix {
    type = string
    default = "mobb"
}

variable operator_role_prefix {
    type = string
    default = "mobbtf"
}

# Module selection
variable create_account_roles {
    type = bool
    description = "Create cluster wide accounts roles"
    default = false
}

variable create_vpc {
    type = bool
    description = "Create custom VPC for ROSA cluster"
    default = false
}

variable create_aad_app {
    type = bool
    description = "Create a Azure AD app for ROSA cluster idp"
    default = false
}

variable create_idp_aad {
    type = bool
    description = "Create Azure AD IDP for ROSA cluster"
    default = false
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
  default     = {
     Terraform = "true"
     Environment = "dev"
     TFOwner = "mobb@redhat.com"
   }
  description = "Additional resource tags"
  type        = map(string)
}

variable multi_az {
    type = bool
    description = "Multi AZ Cluster for High Availability"
    default = false
}

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
    type = string
    default = "AAD"
}

variable "aad_client_id" {
    description = "Azure Application (client) ID"
    default     = "known"
    type = string
}

variable "aad_client_secret" {
    description = "Azure Client credentials"
    default     = "known"
    type = string
    sensitive = true
}

variable "aad_tenant_id" {
    description = "Azure Directory (tenant) ID"
    type = string
    sensitive = true  
}