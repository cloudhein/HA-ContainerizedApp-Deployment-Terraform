resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default_vpc_subnets.ids

  enable_deletion_protection = false

  tags = {
    Name        = "app-lb"
    Environment = "dev"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/ping"
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "app-target-group"
  }
}

#resource "aws_lb_target_group_attachment" "test" {
#  count = var.create_instances ? var.instance_count : 0
#
#  target_group_arn = aws_lb_target_group.app_tg.arn
#  target_id        = aws_instance.web[count.index].id
#  port             = 8080
#
#  depends_on = [aws_lb_target_group.app_tg, aws_instance.web]
#}

# Create a Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP inbound and all outbound"
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_rules" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = local.anywhere
  from_port   = local.http_port
  ip_protocol = local.tcp_protocol
  to_port     = local.http_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = local.anywhere
  ip_protocol       = local.all_protocols_ports # semantically equivalent to all ports
}