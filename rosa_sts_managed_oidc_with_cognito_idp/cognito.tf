resource "aws_cognito_user_pool" "cluster-idp" {
  name                     = "rosa-idp"
  auto_verified_attributes = ["email"]
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = local.cluster_name
  user_pool_id = aws_cognito_user_pool.cluster-idp.id
}

resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.cluster-idp.id
  username     = var.admin_username
  password     = var.admin_password
  attributes = {
    name               = "ROSA Admin"
    email              = "${var.admin_username}@example.com"
    email_verified     = true
    preferred_username = var.admin_username
  }
  message_action = "SUPPRESS"
}

resource "aws_cognito_user_pool_client" "pool_client" {
  name                                 = "pool_client"
  user_pool_id                         = aws_cognito_user_pool.cluster-idp.id
  callback_urls                        = ["https://oauth-openshift.apps.${module.rosa_cluster.domain}/oauth2callback/openid"]
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

resource "rhcs_identity_provider" "oidc_idp" {
  cluster = module.rosa_cluster.cluster_id
  name    = "openid"
  openid = {
    claims = {
      email              = ["email"]
      preferred_username = ["preferred_username"]
      name               = ["name"]
    }
    client_id     = aws_cognito_user_pool_client.pool_client.id
    client_secret = aws_cognito_user_pool_client.pool_client.client_secret
    issuer        = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.cluster-idp.id}"
  }
}
