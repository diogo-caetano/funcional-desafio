terraform {
  backend "s3" {
    bucket = "desafiofuncional"
    key    = "desafiofuncional/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

#Criando VPC
resource "aws_vpc" "VPC_1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "VPC_1"
  }

}
output "aws_vpc_id" {
  value = aws_vpc.VPC_1.id
}

#Criando Subnet
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.VPC_1.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "subnet_1"
  }

}
output "aws_subnet_subnet1" {
  value = aws_subnet.subnet_1.id
}

#Criando Volume Root
resource "aws_ebs_volume" "root" {
  availability_zone = "us-east-1a"
  size              = 15
  tags = {
    "Name" = "Root"
  }
}

#Criando Security Group
resource "aws_security_group" "FUNCIONAL_SG" {
  description = "Administrado por Diogo"
  vpc_id      = aws_vpc.VPC_1.id
  name        = "FUNCIONAL_SG"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8888
    to_port     = 8888
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    "Name" = "FUNCIONAL_SG"
  }

}
output "aws_security_group_id" {
  value = aws_security_group.FUNCIONAL_SG.id
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.keypair
}

#Criando Volume Funcional
resource "aws_ebs_volume" "funcional_dsk" {
  availability_zone = "us-east-1a"
  size              = 15
  tags = {
    "Name" = "Funcional"
  }
}

#Attachando volume funcional a instância

resource "aws_volume_attachment" "sda2" {
  device_name = "/dev/sda2"
  volume_id   = aws_ebs_volume.funcional_dsk.id
  instance_id = aws_instance.servidor1.id
}

#Criando Instância
resource "aws_instance" "servidor1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.FUNCIONAL_SG.id}"]
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = var.instance_name
  }
  root_block_device {
    volume_size = 15
  }

}

output "instance_id" {
  value = aws_instance.servidor1.*.id
}

