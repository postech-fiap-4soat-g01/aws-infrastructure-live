terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
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
