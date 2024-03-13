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

module "ecr_user_authentication" {
  source = "./ecr_user_authentication"
}

module "authentication_lambda_access_key" {
  source = "./authentication_lambda_access_key"
}


# module "lambda" {
#   source = "./lambda"
# }

# module "api_gateway" {
#   source = "./api_gateway"
# }
