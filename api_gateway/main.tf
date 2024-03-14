resource "aws_apigatewayv2_api" "ApiGateway" {
  name          = var.api_name
  protocol_type = var.protocol_type
}

##################################### AUTHORIZER

resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  depends_on = [aws_apigatewayv2_api.ApiGateway]
  api_id          = aws_apigatewayv2_api.ApiGateway.id
  name            = "jwt_authorizer"
  authorizer_type = "JWT"
  identity_sources = [
    "$request.header.Authorization"
  ]
  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.cognito_user_pool_id}"
  }
}

##################################### INTEGRATION


resource "aws_apigatewayv2_integration" "lambda_integration" {
  depends_on = [aws_apigatewayv2_api.ApiGateway]
  api_id          = aws_apigatewayv2_api.ApiGateway.id
  integration_type = "AWS_PROXY"
  integration_method = "POST" 
  integration_uri = var.lambda_arn
  payload_format_version = "2.0"
}

##################################### ROUTES

resource "aws_apigatewayv2_route" "get_users_route" {
  depends_on = [aws_apigatewayv2_api.ApiGateway, aws_apigatewayv2_integration.lambda_integration]
  api_id    = aws_apigatewayv2_api.ApiGateway.id
  route_key = "GET /User/GetUsers"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
#   authorizer_id = aws_apigatewayv2_authorizer.jwt_authorizer.id
#   authorization_type = "JWT"
}

resource "aws_apigatewayv2_route" "authenticate_user_route" {
  depends_on = [aws_apigatewayv2_api.ApiGateway, aws_apigatewayv2_integration.lambda_integration]
  api_id    = aws_apigatewayv2_api.ApiGateway.id
  route_key = "GET /User/AuthenticateUser/{cpf}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "authenticate_as_guest_route" {
  depends_on = [aws_apigatewayv2_api.ApiGateway, aws_apigatewayv2_integration.lambda_integration]
  api_id    = aws_apigatewayv2_api.ApiGateway.id
  route_key = "GET /User/AuthenticateAsGuest"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "create_user_route" {
  depends_on = [aws_apigatewayv2_api.ApiGateway, aws_apigatewayv2_integration.lambda_integration]
  api_id    = aws_apigatewayv2_api.ApiGateway.id
  route_key = "POST /User/CreateUser"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

##################################### STAGE

resource "aws_apigatewayv2_stage" "ApiGatewayStage" {
  depends_on = [aws_apigatewayv2_api.ApiGateway]
  api_id      = aws_apigatewayv2_api.ApiGateway.id
  name        = "ApiGatewayStage"
  auto_deploy = true
}


##################################### PERMISSIONS

resource "aws_lambda_permission" "apigateway_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.ApiGateway.execution_arn}/*/*/User/*"
}
