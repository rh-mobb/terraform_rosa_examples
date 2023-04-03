terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
    ocm = {
      #version = ">= 0.1"
      version = "0.0.2"      
      source  = "terraform-redhat/ocm"
    }
  }
}

provider "ocm" {
  token = var.token
  url = var.url
}


