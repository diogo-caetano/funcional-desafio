#Criando VPC
resource "aws_vpc" "VPC_1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "VPC_1"
  }

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
  depends_on = [
    aws_vpc.VPC_1
  ]

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

  depends_on = [
    aws_vpc.VPC_1
  ]

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC_1.id
  tags = {
    "name" = "igw"
  }

  depends_on = [
    aws_vpc.VPC_1
  ]
}

#Criando route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC_1.id

  route = [{
    //subnet associada pode acessar qualquer local
    cidr_block = "0.0.0.0/0"
    //rt usa essa igw para acessar a internet
    gateway_id                 = "${aws_internet_gateway.igw.id}"
    carrier_gateway_id         = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
  }]

  tags = {
    "name" = "public_rt"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

#Associando route table com subnet
resource "aws_route_table_association" "rt_public_subnet" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
