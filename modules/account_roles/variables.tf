variable "url" {
  type        = string
  description = "Provide OCM environment by setting a value to url"
  default     = "https://api.openshift.com"
}

variable "create_account_roles" {
  description = "This attribute determines whether the module should create account roles or not"
  type        = bool
  default     = false
}

variable "account_role_prefix" {
  type    = string
  default = ""
}

variable "rosa_openshift_version" {
  description = "Desired version of OpenShift for the cluster, for example '4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
  type        = string
  default     = "4.12"
}

variable "ocm_environment" {
  description = "The OCM environments should be one of those: production, staging, integration, local"
  type        = string
  default     = "production"
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

variable additional_tags {
    type = map(string)
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}
