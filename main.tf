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

