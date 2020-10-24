resource "aws_security_group" lb_sg {
  vpc_id = aws_vpc.demo.id

  ingress {
    description = "incoming port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outoing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" alb {
  name               = "demo"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.lb_sg.id]

  tags = {
    Name = "demo lb"
  }
}

resource "aws_lb_listener" lb_listener {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_servers.arn
  }
}

resource "aws_lb_target_group" app_servers {
  name        = "app-servers"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo.id

}

resource "aws_lb_target_group_attachment" lb_tg_attach_a {
  target_group_arn = aws_lb_target_group.app_servers.arn
  target_id        = aws_instance.web_a.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" lb_tg_attach_b {
  target_group_arn = aws_lb_target_group.app_servers.arn
  target_id        = aws_instance.web_b.id
  port             = 8080
}
