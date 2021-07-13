#Informando s3 criada para armazenar os arquivos tfstate
terraform {
  backend "s3" {
    bucket = "desafiofuncional"
    key    = "desafiofuncional/terraform.tfstate"
    region = "us-east-1"
  }

#Informando provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

#Criando Volume Root
resource "aws_ebs_volume" "root" {
  availability_zone = "us-east-1a"
  size              = 15
  tags = {
    "Name" = "Root"
  }
}

#Criando Volume Funcional
resource "aws_ebs_volume" "funcional_dsk" {
  availability_zone = "us-east-1a"
  size              = 15
  tags = {
    "Name" = "Funcional"
  }
}
#Associando par de chaves
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.keypair
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

#Attachando volume funcional a instância
resource "aws_volume_attachment" "sda2" {
  device_name = "/dev/sda2"
  volume_id   = aws_ebs_volume.funcional_dsk.id
  instance_id = aws_instance.servidor1.id
}