#kubernetes-flannel
resource "aws_security_group" "kuber_flnl" {
  name        = "kube_flannel"
  vpc_id      = aws_vpc.kubernetes_vpc.id

  ingress {
    description = "UDP from VPC"
    from_port   = 8285
    to_port     = 8285
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "UDP from VPC"
    from_port   = 8472
    to_port     = 8472
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kubernete-flannel"
  }
}
