resource "aws_lb" "test-alb" {
  name               = "test-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.test-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      status_code  = "200"
      message_body = "pong"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_security_group_rule" "lb_sg_rule" {
  security_group_id = aws_security_group.lb_sg.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
