variable token {
  type = string
  sensitive = true
}

variable operator_role_prefix {
    type = string
}

variable cluster_id {
    type = string
}

variable oidc_endpoint_url {
    type = string
}

variable oidc_thumbprint {
    type = string
}

variable account_role_prefix {
    type = string
}

variable url {
    type = string
    default = "https://api.openshift.com"
}

variable additional_tags {
    type = map(string)
}

variable managed_oidc {
    type = bool
    description = "Red Hat managed or unmanaged (Customer hosted) OIDC Configuration"
    default = true
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}