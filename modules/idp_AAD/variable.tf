variable token {
  type = string
  sensitive = true
}

variable url {
    type = string
    default = "https://api.openshift.com"
}

variable "cluster_name" {
    type = string
    default = "kumudu-tf-test"
  
}
variable "idp_name" {
    type = string
    default = "AAD"
}

variable "aad_client_id" {
    description = "Azure Application (client) ID"
    type = string
    default = "XXXXX"  
}

variable "aad_client_secret" {
    description = "Azure Client credentials"
    type = string
    default = "XXXX"  
}

variable "aad_tenant_id" {
    description = "Azure Directory (tenant) ID"
    type = string
    default = "XXX"
    sensitive = true  
}
