#resource "aws_vpc" demo {
#  cidr_block = "172.20.0.0/16"
#
#  tags = {
#    Name = "demo"
#  }
#}
#
#resource "aws_subnet" public_a {
#  vpc_id            = aws_vpc.demo.id
#  cidr_block        = "172.20.0.0/18"
#  availability_zone = data.aws_availability_zones.available.names[0]
#
#  tags = {
#    Name = "public a"
#  }
#
#}
#
#resource "aws_subnet" public_b {
#  vpc_id            = aws_vpc.demo.id
#  cidr_block        = "172.20.64.0/18"
#  availability_zone = data.aws_availability_zones.available.names[1]
#
#  tags = {
#    Name = "public b"
#  }
#}
#
#resource "aws_subnet" public_c {
#  vpc_id            = aws_vpc.demo.id
#  cidr_block        = "172.20.128.0/18"
#  availability_zone = data.aws_availability_zones.available.names[2]
#
#  tags = {
#    Name = "public c"
#  }
#}
#
#resource "aws_internet_gateway" gw {
#  vpc_id = aws_vpc.demo.id
#  tags = {
#    Name = "demo"
#  }
#}
#
#resource "aws_route_table" demo {
#  vpc_id = aws_vpc.demo.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gw.id
#  }
#
#  tags = {
#    Name = "demo"
#  }
#}
#
#resource "aws_route_table_association" public_a {
#  route_table_id = aws_route_table.demo.id
#  subnet_id      = aws_subnet.public_a.id
#}
#
#resource "aws_route_table_association" public_b {
#  route_table_id = aws_route_table.demo.id
#  subnet_id      = aws_subnet.public_b.id
#}
#
#resource "aws_route_table_association" public_c {
#  route_table_id = aws_route_table.demo.id
#  subnet_id      = aws_subnet.public_c.id
#}

