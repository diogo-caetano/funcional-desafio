variable "aws_access_key" {
  description = "AWS Access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "aws_region" {
  description = "AWS default region"
  type        = string
}

variable "aws_availability_zone" {
  description = "AWS default availability zone"
  type        = string
}

variable "aws_instance_name" {
  description = "valor da tag Name setada como Funcional"
  type        = string
}

variable "aws_instance_type" {
  description = "Tipo de Instância EC2 a ser utilizada"
  type        = string
}

variable "ami" {
  description = "AMI a ser usada na instância ec2"
  type        = string
}

variable "key_name" {
  description = "Chave usada para acessar o server via SSH"
  type        = string
}

variable "keypair" {
  description = "sha da Chave PEM"
  type        = string
}


