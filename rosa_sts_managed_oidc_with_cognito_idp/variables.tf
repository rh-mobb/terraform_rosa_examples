variable "cluster_name" {
  type = string
  default = null
}

#AWS Info
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "admin_username" {
  description = "The username you want your AWS Cognito user to have"
  type        = string
}

variable "admin_password" {
  description = "The password you want your AWS Cognito user to have"
  type        = string
  sensitive   = true
}
