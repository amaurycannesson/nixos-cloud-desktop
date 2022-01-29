provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "cloud_desktop_sg" {
  name = "cloud-desktop-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "generated_keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local_private_key_file" {
  filename             = pathexpand("~/.ssh/${var.cloud_desktop_key_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.generated_keys.private_key_pem
}

resource "aws_key_pair" "cloud_desktop_kp" {
  key_name   = var.cloud_desktop_key_name
  public_key = tls_private_key.generated_keys.public_key_openssh
}

data "aws_ami" "cloud_desktop_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["nixos-cloud-desktop"]
  }
}

resource "aws_instance" "cloud_desktop" {
  ami                    = data.aws_ami.cloud_desktop_ami.id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.cloud_desktop_sg.id]
  key_name               = aws_key_pair.cloud_desktop_kp.key_name

  tags = {
    Name = "NixOS Cloud Desktop"
  }
}
