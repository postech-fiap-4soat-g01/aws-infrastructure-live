resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "rds_subnet_a" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = " us-east-1a"
}

resource "aws_subnet" "rds_subnet_b" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = aws_vpc.rds_vpc.id

  # Add any additional ingress/egress rules as needed
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

