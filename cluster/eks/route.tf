resource "aws_route_table" "eks-route-table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.net_gateway.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "eks-public-us-east-1a" {
  subnet_id      = aws_subnet.eks-public-us-east-1a.id
  route_table_id = aws_route_table.eks-route-table.id
}

resource "aws_route_table_association" "eks-public-us-east-1b" {
  subnet_id      = aws_subnet.eks-public-us-east-1b.id
  route_table_id = aws_route_table.eks-route-table.id
}