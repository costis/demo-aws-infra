data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # cAnonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}

resource "aws_instance" bastion {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" bastion {
  vpc_id      = aws_vpc.demo.id
  description = "Access to bastion"
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group_rule" ssh {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" bastion-outbound {
  type              = "egress"
  security_group_id = aws_security_group.bastion.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" bastion-db-inbound {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

# resource "aws_security_group_rule" bastion-db-outbound {
#   type                     = "egress"
#   security_group_id        = aws_security_group.db.id
#   source_security_group_id = aws_security_group.app_server.id
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "tcp"
# }
#
resource "aws_instance" web_a {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_a.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.app_server.id]

  tags = {
    Name = "app_a"
  }
}

resource "aws_instance" web_b {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_b.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.app_server.id]

  tags = {
    Name = "app_b"
  }
}

resource "aws_security_group" app_server {
  vpc_id      = aws_vpc.demo.id
  description = "Access to app server"
  tags = {
    Name = "app_server"
  }
}

resource "aws_security_group_rule" app_server_ssh {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_server.id
  source_security_group_id = aws_security_group.bastion.id
  description              = "inbound ssh"
}

resource "aws_security_group_rule" app_server_tcp_8080_elb {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_server.id
  source_security_group_id = aws_security_group.lb_sg.id
  description              = "inbound tcp 8080 from alb"
}

resource "aws_security_group_rule" app_server_tcp_8080_vpc {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.app_server.id
  cidr_blocks       = [aws_vpc.demo.cidr_block]
  description       = "inbound tcp 8080 from vpc"
}

resource "aws_security_group_rule" app_server-db-inbound {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_server.id
}

resource "aws_security_group_rule" app_server-db-outbound {
  type                     = "egress"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.app_server.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
}

resource "aws_security_group_rule" app_server_egress {
  type              = "egress"
  security_group_id = aws_security_group.app_server.id
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow all outbound"
}

