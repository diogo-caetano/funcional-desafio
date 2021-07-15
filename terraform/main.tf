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

#Criando Volume Funcional
resource "aws_ebs_volume" "funcional_dsk" {
  availability_zone = var.aws_availability_zone
  size              = 15
  tags = {
    "Name" = "Funcional"
  }
  depends_on = [
    aws_instance.servidor1
  ]
}
#Associando par de chaves
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.keypair
}

#Criando Instância
resource "aws_instance" "servidor1" {
  ami                         = var.ami
  instance_type               = var.aws_instance_type
  vpc_security_group_ids      = ["${aws_security_group.FUNCIONAL_SG.id}"]
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  volume_tags = {
    Name = "Root"
  }
  tags = {
    Name = var.aws_instance_name
  }
  root_block_device {
    volume_size = 15
  }
  depends_on = [
    aws_key_pair.deployer,
    aws_vpc.VPC_1
  ]
}

#Attachando volume funcional a instância
resource "aws_volume_attachment" "sda2" {
  device_name = "/dev/sda2"
  volume_id   = aws_ebs_volume.funcional_dsk.id
  instance_id = aws_instance.servidor1.id
  depends_on = [
    aws_instance.servidor1,
    aws_ebs_volume.funcional_dsk
  ]
}

#Criando bucket s3 para backup
resource "aws_s3_bucket" "bucketbkp" {
  bucket = "desafiofuncionalbkp"
  acl    = "private"
  tags = {
    Name        = "Funcional Bkp"
  }
}