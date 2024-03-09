resource "aws_db_instance" "rds-mssql" {
  engine            = "sqlserver-ex"
  engine_version    = "15.00"
  instance_class    = "db.t3.large"
  identifier        = "mydb"
  username          = "dbuser"
  password          = "dbpassword"

  allocated_storage     = 20
  max_allocated_storage = 100

  port     = 1433

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}