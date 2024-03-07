terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }

  cloud {
    organization = var.organization

  workspaces {
      name = var.workspace
    }
  }
}

provider "aws" {
  region = var.region
}
