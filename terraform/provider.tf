terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
   ansible = {
      source = "ansible/ansible"
      version = "1.1.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}