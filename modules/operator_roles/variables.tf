variable "url" {
  type        = string
  description = "Provide OCM environment by setting a value to url"
  default     = "https://api.openshift.com"
}

variable "create_operator_roles" {
  description = "This attribute determines whether the module should create operator roles or not"
  type        = bool
  default     = false
}


variable operator_role_prefix {
    type = string
}

variable oidc_endpoint_url {
    type = string
}

variable oidc_thumbprint {
    type = string
}

variable additional_tags {
    type = map(string)
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}
