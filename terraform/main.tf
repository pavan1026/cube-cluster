
resource "aws_instance" "kubernetes_master1" { 
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.kubernetes_keypair.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [ aws_security_group.kubernetes_ssh_https.id, aws_security_group.kubernetes_control.id, aws_security_group.kuber_flnl.id]
  tags = {
    Name = "Kubernetes_master1"
  }
  provisioner "local-exec" {
    command = "echo 'master ${self.public_ip}' >> ../files/hosts"
  }
}
resource "aws_instance" "kubernetes_worker" { 
  ami                         = var.aws_ami
  count                       = 2
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.kubernetes_keypair.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [ aws_security_group.kubernetes_ssh_https.id, aws_security_group.kubernetes_worker_node.id, aws_security_group.kuber_flnl.id]
  tags = {
    Name = "Kubernetes_worker${count.index}"
  }
  provisioner "local-exec" {
    command = "echo 'worker-${count.index} ${self.public_ip}' >> ../files/hosts"
  }
}

resource "null_resource" "chmod-400-private-key" {
  depends_on = [ aws_key_pair.kubernetes_keypair ]
 provisioner "local-exec" {

    command = "chmod 400 ../private-key.pem"
  }
}
#ansible related resources
resource "ansible_host" "kube_control_plane_host" {
  depends_on = [ 
    aws_instance.kubernetes_master1 
  ]
  name = "control_plane"
  groups = ["master"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = aws_instance.kubernetes_master1.public_ip
    ansible_ssh_private_key_file = "../private-key.pem"
    node_hostname = "master"
  }
}

resource "ansible_host" "kube_worker_node_host" {
  depends_on = [ 
    aws_instance.kubernetes_worker 
  ]
  count = 2
  name = "worker-${count.index}"
  groups = ["workers"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = aws_instance.kubernetes_worker[count.index].public_ip
    ansible_ssh_private_key_file = "../private-key.pem"
    node_hostname = "worker-${count.index}"
  }

}