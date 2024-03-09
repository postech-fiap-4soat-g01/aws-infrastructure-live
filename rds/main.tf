data "aws_availability_zones" "available" {}

locals {
  name    = "rds-mssql"
  region  = "us-east-1"
  region2 = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
}

module "db" {
  source = "../../"

  identifier = local.name

  engine               = "sqlserver-ex"
  engine_version       = "15.00"
  family               = "sqlserver-ex-15.0"
  major_engine_version = "15.00"
  instance_class       = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_encrypted = false

  username = "complete_mssql"
  port     = 1433

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  options                   = []
  create_db_parameter_group = false
  license_model             = "license-included"
  timezone                  = "GMT Standard Time"
  character_set_name        = "Latin1_General_CI_AS"

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  create_database_subnet_group = true
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "SqlServer security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "SqlServer access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  # egress
  egress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "Allow outbound communication to Directory Services security group"
      source_security_group_id = aws_directory_service_directory.demo.security_group_id
    },
  ]

  tags = local.tags
}