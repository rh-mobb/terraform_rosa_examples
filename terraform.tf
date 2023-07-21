terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }    
    ocm = {
      source  = "terraform-redhat/ocm"
      #version = ">= 0.1"
      version = "1.0.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region
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

provider "ocm" {
  token = var.token
  url = var.url
}