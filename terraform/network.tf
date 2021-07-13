resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC_1.id
  tags = {
    "name" = "igw"
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC_1.id

  route = [{
    //associate subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //rt uses this igw to reach internet
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
}

resource "aws_route_table_association" "rt_public_subnet" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id

}
