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

resource "aws_route_table_association" "eks-route-table-association" {
  count = 2

  subnet_id      = aws_subnet.eks-subnet[count.index].id
  route_table_id = aws_route_table.eks-route-table.id
}