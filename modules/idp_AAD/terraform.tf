terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = ">= 3.67"
      version = "~> 4.0"
    }
    ocm = {
      version = "= 0.0.2"
      source  = "terraform-redhat/ocm"
    }
  }
}

provider "ocm" {
  token = var.token
  url = var.url
}