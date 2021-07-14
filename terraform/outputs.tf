output "instance_public_ip" {
  description = "IP publico da instância EC2"
  value       = aws_instance.servidor1.public_ip
}

output "instance_vpc" {
  value = aws_vpc.VPC_1.id
}

output "instance_subnet" {
  value = aws_subnet.subnet_1.id
}

output "aws_vpc_id" {
  value = aws_vpc.VPC_1.id
}

output "aws_subnet_subnet1" {
  value = aws_subnet.subnet_1.id
}

output "aws_security_group_id" {
  value = aws_security_group.FUNCIONAL_SG.id
}

output "instance_id" {
  value = aws_instance.servidor1.*.id
}