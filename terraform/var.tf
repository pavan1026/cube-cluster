variable "kubernetes_key_pair" {
  type        = string
  description = "keypair for kubrnetes master and worker nodes"
  default     = "kubernetes_key_pair"
}

variable "instance_type" {
  type        = string
  description = "type of instance"
  default     = "t2.medium"
}

variable "aws_ami" {
  type        = string
  description = "ami id of instance"
  default     = "ami-0505148b3591e4c07"
}