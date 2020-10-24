resource "aws_security_group" db {
  vpc_id      = aws_vpc.demo.id
  description = "main db"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "Demo subnet group"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "demo"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.9"
  instance_class         = "db.t3.micro"
  name                   = "demo"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  availability_zone      = data.aws_availability_zones.available.names[0]
  multi_az               = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db.id]
}
