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
  source = "./authentication_lambda_access_key"
}


module "lambda" {
  source = "./lambda"

  access_key_id    = module.authentication_lambda_access_key.access_key_id
  secret_access_key = module.authentication_lambda_access_key.secret_access_key
  dynamodb_table_name       = module.dynamo.dynamodb_table_name
  cognito_user_pool_id      = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  lambda_role = module.authentication_lambda_access_key.lambda_role
}

module "api_gateway" {
  source = "./api_gateway"

  cognito_user_pool_id      = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  lambda_arn = module.lambda.lambda_arn
  lambda_name = module.lambda.lambda_name
}
