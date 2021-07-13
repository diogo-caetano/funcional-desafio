variable "aws_access_key" {
  type        = string
  description = "AWS Access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS default region"
}

variable "instance_name" {
  description = "valor da tag Name setada como Funcional"
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

variable "instance_type" {
  description = "Tipo de Instância EC2 a ser utilizada"
  type        = string
}

variable "keypair" {
  description = "sha da Chave PEM"
  type = string
}
