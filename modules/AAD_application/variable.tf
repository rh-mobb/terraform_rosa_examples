variable create_aad_app {
    type = bool
    description = "Create a Azure AD app for ROSA cluster idp"
    default = false
}

variable "aad_app_name" {
  type        = string
  default     = "kumudu-tf-test-app"
  description = "Azure AD App Name"
}

variable "aad_app_password_name" {
  type        = string
  default     = "ROSA-Secret"
  description = "AAD Secret Name"
}

variable "aad_app_redirect_uri" {
  type        = string
  default     = "https://oauth-openshift.apps.kumudu-tf-test.a531.p1.openshiftapps.com/oauth2callback/AAD"
  description = "AAD App Redirect_uri"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

