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
    default = "f0cb833b-e271-4638-8285-36975513ab43"  
}

variable "aad_client_secret" {
    description = "Azure Client credentials"
    type = string
    default = "Gvw8Q~66_fZ9G5UHT6YtqJH56DnAUhJeGZbEdbKQ"  
}

variable "aad_tenant_id" {
    description = "Azure Directory (tenant) ID"
    type = string
    default = "64dc69e4-d083-49fc-9569-ebece1dd1408"
    sensitive = true  
}