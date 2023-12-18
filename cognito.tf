resource "aws_cognito_user_pool" "user_pool" {
  name = "cognito-cyclone-user-pool"

  tags = {
    Name        = "cognito-cyclone-user-pool"
    Environment = "prod"
    Group       = "cyclone"
  }
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "cognito-cyclone-identity-pool"
  allow_unauthenticated_identities = true

  tags = {
    Name        = "cognito-cyclone-identity-pool"
    Environment = "prod"
    Group       = "cyclone"
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "cyclone-auth"
  user_pool_id = aws_cognito_user_pool.user_pool.id

}

resource "aws_cognito_user_pool_client" "client" {
  name            = "cognito-cyclone-client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = true

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH"]
}

