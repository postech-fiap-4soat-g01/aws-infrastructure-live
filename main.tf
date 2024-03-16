terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "postech_soat"

    workspaces {
      name = "aws-infrastructure-live"
    }
  }
}

provider "aws" {
  region = var.region
}

module "cluster_rds" {
  source = "./cluster_rds"
}

module "ecr" {
  source = "./ecr"
}

module "dynamo" {
  source = "./dynamo"
}

module "cloudwath" {
  source = "./cloudwatch"
}

module "cognito" {
  source = "./cognito"
}

module "authentication_lambda_access_key" {
  count = var.create_lambda ? 1 : 0
  source = "./authentication_lambda_access_key"
}


module "lambda" {
  count = var.create_lambda ? 1 : 0
  source = "./lambda"

  access_key_id               = module.authentication_lambda_access_key.access_key_id
  secret_access_key           = module.authentication_lambda_access_key.secret_access_key
  dynamodb_table_name         = module.dynamo.dynamodb_table_name
  cognito_user_pool_id        = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  lambda_role                 = module.authentication_lambda_access_key.lambda_role
}

module "api_gateway" {
  count = var.create_lambda ? 1 : 0
  source = "./api_gateway"

  cognito_user_pool_id        = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  lambda_arn                  = module.lambda.lambda_arn
  lambda_name                 = module.lambda.lambda_name
  lb_dns_name                 = module.load_balancer.lb_dns_name
  aws_lb_listener_arn         = module.load_balancer.aws_lb_listener_arn
  private_subnets_ids         = module.cluster_rds.private_subnets_ids
}

module "load_balancer" {
  count = var.create_lambda ? 1 : 0
  source = "./load_balancer"

  vpc_id              = module.cluster_rds.vpc_id
  security_group_id   = module.cluster_rds.security_group_id
  private_subnets_ids = module.cluster_rds.private_subnets_ids
}
