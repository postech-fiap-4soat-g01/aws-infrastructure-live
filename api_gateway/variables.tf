variable "api_name" {
  default = "FastFoodTotemApi"
  type    = string
}

variable "protocol_type" {
  default = "HTTP"
  type    = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "api_version" {
  default = "1"
}



variable "cognito_user_pool_client_id" {}
variable "lambda_arn" {}
variable "cognito_user_pool_id" {}
variable "lambda_name" {}
variable "lb_dns_name" {}
variable "aws_lb_listener_arn" {}
variable "private_subnets_ids" {}

variable "load_balancer_arn" {}
variable "load_balancer_dns" {}
