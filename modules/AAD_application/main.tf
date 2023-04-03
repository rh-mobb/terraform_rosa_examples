
data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

# So we don't need to lookup the role IDs manually
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}


resource "azuread_application" "aad_app" {
    count = var.create_aad_app ? 1 : 0
    display_name            = var.aad_app_name
    owners                  = [data.azuread_client_config.current.object_id]
    sign_in_audience        = "AzureADMyOrg"

    optional_claims {
        id_token {
            name            = "upn"
        }

        id_token {
            name            = "email"
        }
    }

    required_resource_access {
        resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

        resource_access {
            id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
            type = "Scope"
        }
        # Group.Read.All, "GroupMember.Read.All and User.Read.All are required. 
        # When use name ID are not matched. Hence Static IDS from MS graph are used
        resource_access {
            #id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["Group.Read.All"]
            id   = "5b567255-7703-4780-807c-7be8301ae99b"
            type = "Role"
        }

        resource_access {
            #id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["GroupMember.Read.All"]
            id = "98830695-27a2-44f7-8c18-0c3ebc9698f6"
            type = "Role"
        }

        resource_access {
            #id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read.All"]
            id = "df021288-bdef-4463-88db-98f22de89214"
            type = "Role"
        }               
    }


    web {
        redirect_uris       = [var.aad_app_redirect_uri]

        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = true
        }
    }
}


#Create Service Principal for the App Registration (required) 
resource "azuread_service_principal" "aad_app" {
    count = var.create_aad_app ? 1 : 0
    application_id  = var.create_aad_app ? azuread_application.aad_app[0].application_id : null
    #application_id  = azuread_application.aad_app.application_id
    #owners          = [data.azuread_client_config.current.object_id]
}

#Create client secret for the App
resource "azuread_application_password" "aad_app" {
    count = var.create_aad_app ? 1 : 0
    application_object_id = var.create_aad_app ? azuread_application.aad_app[0].object_id : null
    #application_object_id = azuread_application.aad_app.object_id
    display_name = var.create_aad_app ? var.aad_app_password_name : null
}