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

module "cluster" {
  source = "./cluster/eks"
}

module "rds" {
  source = "./rds"
}

module "ecr" {
  source = "./ecr"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambda" {
  source = "./lambda"
}
