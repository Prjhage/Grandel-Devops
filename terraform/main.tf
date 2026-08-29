terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Automatically generate SSH Key pair
resource "tls_private_key" "grandel_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register Key Pair on AWS
resource "aws_key_pair" "grandel_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.grandel_key.public_key_openssh
}

# Save private key file locally for SSH and Ansible
resource "local_file" "private_key" {
  content  = tls_private_key.grandel_key.private_key_pem
  filename = "${path.module}/../fa1-key.pem"
}

resource "aws_instance" "grandel_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.grandel_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.grandel_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name    = "grandel-server"
    Project = "Grandel"
  }
}
