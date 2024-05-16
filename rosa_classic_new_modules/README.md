# Terraform plan to make a privatelink ROSA cluster
Creates:

- VPC and relevant stuff (optionally)
- ROSA Account Roles
- ROSA Operator Roles
- Unmanaged OIDC provider
- COMING SOON: CloudFront Distribution in front of OIDC config bucket

## Usage:

```
terraform init
terraform apply
```
