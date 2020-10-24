resource "aws_vpc" demo {
  cidr_block = "172.20.0.0/16"
  tags = {
    Name = "demo"
  }
}

resource "aws_internet_gateway" gw {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo"
  }
}

# public subnets
resource "aws_subnet" public_a {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "172.20.0.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" public_b {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "172.20.16.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "public_b"
  }
}

# private subnets
resource "aws_subnet" private_a {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "172.20.32.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "private_a"
  }
}

resource "aws_subnet" private_b {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "172.20.48.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "private_b"
  }
}

# NATs
resource "aws_eip" nat_a {
  vpc = true
}

resource "aws_eip" nat_b {
  vpc = true
}

resource "aws_nat_gateway" nat_a {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id
}

resource "aws_nat_gateway" nat_b {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id
}

# routing
resource "aws_route_table" public_subnet {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "demo"
  }
}

resource "aws_route_table_association" public_a {
  route_table_id = aws_route_table.public_subnet.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" public_b {
  route_table_id = aws_route_table.public_subnet.id
  subnet_id      = aws_subnet.public_b.id
}
# private subnet routes
resource aws_route_table private_a {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
}
resource aws_route_table private_b {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }
}

resource "aws_route_table_association" private_a {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" private_b {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}
