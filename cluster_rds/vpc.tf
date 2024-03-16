data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = module.vpc.vpc_id

  # Add any additional ingress/egress rules as needed
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

output "managed_node_group_security_group_ids" {
  value = {
    for name, node_group in data.aws_eks_cluster.cluster.node_groups : name => node_group.remote_access_security_group_id
  }
}

resource "aws_security_group_rule" "allow-workers-nodes-communications" {
  description              = "Allow worker nodes to communicate with database"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rds_sg.id}"
  source_security_group_id = "${output.managed_node_group_security_group_ids}"
  to_port                  = 3306
  type                     = "ingress"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets
}