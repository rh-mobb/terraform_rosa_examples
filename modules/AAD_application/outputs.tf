output "application_id" {
    description = "Application (client) ID"
    #value       = var.create_vpc ? module.vpc[0].public_subnets : []
    #azuread_application.aad_app.application_id
    value =  var.create_aad_app ? azuread_service_principal.aad_app[0].application_id : null
}

output "directory_id" {
    description = "Directory (tenant) ID"
    value =  var.create_aad_app ? azuread_service_principal.aad_app[0].application_tenant_id : null
}

output "secret_id" {
    description = "Client ID"
    value =  var.create_aad_app ? azuread_application_password.aad_app[0].id : null
    #sensitive = true
}

output "secret_value" {
    description = "Client credentials"
    value =  var.create_aad_app ? azuread_application_password.aad_app[0].value : null
    sensitive = true
}
