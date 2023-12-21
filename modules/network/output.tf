output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = var.create_vpc ? module.vpc[0].private_subnets : []
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = var.create_vpc ? module.vpc[0].public_subnets : []
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = var.create_vpc ? module.vpc[0].vpc_id : null
}
