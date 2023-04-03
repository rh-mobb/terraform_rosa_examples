terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "~>2.24"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  #Add your tenant id if you have multiple tenants
  # tenant_id = "XXXX-XXXX-XXX-XXXX"
}