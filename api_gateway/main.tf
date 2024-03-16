data "aws_lb" "fast_food_totem" {
  name = "fast-food-totem"
}

resource "aws_api_gateway_vpc_link" "main" {
 name = "foobar_gateway_vpclink"
 description = "Foobar Gateway VPC Link. Managed by Terraform."
 target_arns = [data.aws_lb.fast_food_totem.arn]
}

resource "aws_api_gateway_rest_api" "main" {
 name = "foobar_gateway"
 description = "Foobar Gateway used for EKS. Managed by Terraform."
 endpoint_configuration {
   types = ["REGIONAL"]
 }
}

##################################### API

resource "aws_apigatewayv2_api" "ApiGateway" {
  name          = var.api_name
  protocol_type = var.protocol_type
}

##################################### AUTHORIZER

resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  depends_on      = [aws_apigatewayv2_api.ApiGateway]
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

resource "aws_apigatewayv2_vpc_link" "vpc_link_api_to_lb" {
  name               = "vpc_link_api_to_lb"
  security_group_ids = []
  subnet_ids         = var.private_subnets_ids
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  depends_on             = [aws_apigatewayv2_api.ApiGateway]
  api_id                 = aws_apigatewayv2_api.ApiGateway.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = var.lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "load_balancer_integration" {
  depends_on             = [aws_apigatewayv2_api.ApiGateway]
  api_id                 = aws_apigatewayv2_api.ApiGateway.id

  uri                     = "http://${data.aws_lb.fast_food_totem.dns_name}/{proxy}"
  integration_type       = "HTTP_PROXY"
  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.main.id

  integration_method     = "ANY"
  payload_format_version = "1.0"

  request_parameters = {
    "integration.request.path.proxy"           = "method.request.path.proxy"
    "integration.request.header.Accept"        = "'application/json'"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

##################################### ROUTES

resource "aws_apigatewayv2_route" "load_balancer_route_order" {
  depends_on         = [aws_apigatewayv2_integration.load_balancer_integration]
  api_id             = aws_apigatewayv2_api.ApiGateway.id
  route_key          = "ANY /v${var.api_version}/order/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.load_balancer_integration.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_route" "load_balancer_route_product" {
  depends_on         = [aws_apigatewayv2_integration.load_balancer_integration]
  api_id             = aws_apigatewayv2_api.ApiGateway.id
  route_key          = "ANY /v${var.api_version}/product/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.load_balancer_integration.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  depends_on = [aws_apigatewayv2_api.ApiGateway, aws_apigatewayv2_integration.lambda_integration]
  api_id     = aws_apigatewayv2_api.ApiGateway.id
  route_key  = "ANY /User/{proxy+}"
  target     = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

##################################### STAGE

resource "aws_apigatewayv2_stage" "ApiGatewayStage" {
  depends_on  = [aws_apigatewayv2_api.ApiGateway]
  api_id      = aws_apigatewayv2_api.ApiGateway.id
  name        = "ApiGatewayStage"
  auto_deploy = true
}

##################################### PERMISSIONS

resource "aws_lambda_permission" "apigateway_invoke_lambda" {
  depends_on    = [aws_apigatewayv2_api.ApiGateway]
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.ApiGateway.execution_arn}/*/*/User/*"
}
