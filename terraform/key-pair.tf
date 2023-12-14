#NOTE instance related resouces
resource "tls_private_key" "kubernetes_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
  provisioner "local-exec" {
    command = "echo '${self.public_key_openssh }' > ../pubkey.pem"
  }
}

resource "aws_key_pair" "kubernetes_keypair" {
  key_name   = var.kubernetes_key_pair
  public_key = tls_private_key.kubernetes_private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.kubernetes_private_key.private_key_pem}' > ../private-key.pem"
  }
}