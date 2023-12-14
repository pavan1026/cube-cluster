#custom route table
resource "aws_route_table" "kubernetes_route_table" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubernetes_igw.id
  }
  tags = {
    Name = "kubernetes_routetable"
  }
}
#associate route table to subnet
resource "aws_route_table_association" "kubernetes_rt_asso" {
  subnet_id      = aws_subnet.kubernetes_subnet.id
  route_table_id = aws_route_table.kubernetes_route_table.id
}