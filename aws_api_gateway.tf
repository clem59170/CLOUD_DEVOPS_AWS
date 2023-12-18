resource "aws_api_gateway_rest_api" "api" {
  name        = "cyclone-api-gateway"
  description = "API Gateway sécurisée pour le projet Cyclone"

  tags = {
    Name        = "cyclone-api-gateway"
    Environment = "prod"
    Group       = "cyclone"
  }
}

resource "aws_api_gateway_resource" "fetch_messages" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "fetch-messages"
}

resource "aws_api_gateway_method" "get_messages" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.fetch_messages.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.my_authorizer.id
}

resource "aws_api_gateway_resource" "post_message" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "post-message"
}

resource "aws_api_gateway_method" "post_message" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.post_message.id
  http_method   = "POST"
  authorizer_id = aws_api_gateway_authorizer.my_authorizer.id
  authorization = "COGNITO_USER_POOLS"

}

resource "aws_api_gateway_authorizer" "my_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.api.id
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.user_pool.arn]
  type            = "COGNITO_USER_POOLS"

}

# Permissions pour que l'API Gateway puisse appeler Lambda
resource "aws_lambda_permission" "api_gateway_permission_fetch" {
  statement_id  = "AllowExecutionFromAPIGatewayFetch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fetch_messages.arn
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "api_gateway_permission_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_message.arn
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_integration" "get_messages_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.fetch_messages.id
  http_method             = aws_api_gateway_method.get_messages.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fetch_messages.invoke_arn
}

# Intégration Lambda pour POST post_message
resource "aws_api_gateway_integration" "post_message_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.post_message.id
  http_method             = aws_api_gateway_method.post_message.http_method
  integration_http_method = aws_api_gateway_method.post_message.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.post_message.invoke_arn
}

resource "aws_api_gateway_deployment" "my_deployment" {
  depends_on = [
    aws_api_gateway_method.get_messages,
    aws_api_gateway_method.post_message,
    aws_api_gateway_integration.get_messages_integration,
    aws_api_gateway_integration.post_message_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"

}

# Réponse de méthode pour GET fetch-messages
resource "aws_api_gateway_method_response" "get_messages_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.fetch_messages.id
  http_method = aws_api_gateway_method.get_messages.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Réponse de méthode pour POST post-message
resource "aws_api_gateway_method_response" "post_message_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.post_message.id
  http_method = aws_api_gateway_method.post_message.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method" "options_fetch_messages" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.fetch_messages.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_fetch_messages_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.fetch_messages.id
  http_method = aws_api_gateway_method.options_fetch_messages.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_fetch_messages" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.fetch_messages.id
  http_method = aws_api_gateway_method.options_fetch_messages.http_method
  status_code = aws_api_gateway_method_response.options_fetch_messages_200.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
}

resource "aws_api_gateway_integration" "options_fetch_messages" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.fetch_messages.id
  http_method             = aws_api_gateway_method.options_fetch_messages.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method" "options_post_messages" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.post_message.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_post_messages_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.post_message.id
  http_method = aws_api_gateway_method.options_post_messages.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_post_messages" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.post_message.id
  http_method = aws_api_gateway_method.options_post_messages.http_method
  status_code = aws_api_gateway_method_response.options_post_messages_200.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
}

resource "aws_api_gateway_integration" "options_post_messages" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.post_message.id
  http_method             = aws_api_gateway_method.options_post_messages.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}






