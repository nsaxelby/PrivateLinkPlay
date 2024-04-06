resource "aws_lb" "my-nlb" {
  name               = "my-nlb-vpc1"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_1.id
    allocation_id = aws_eip.eip1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_2.id
    allocation_id = aws_eip.eip2.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_3.id
    allocation_id = aws_eip.eip3.id
  }
}


resource "aws_eip" "eip1" {
  domain = "vpc"
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

resource "aws_eip" "eip3" {
  domain = "vpc"
}

resource "aws_lb_listener" "my-listener" {
  load_balancer_arn = aws_lb.my-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}

resource "aws_lb_target_group" "my-target-group" {
  name        = "tf-example-lb-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc1.id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = aws_lb.test-alb.arn
  port             = 80
  depends_on       = [aws_lb.test-alb]
}

output "execute_this_curl_to_ping_alb_through_nbl" {
  value = "curl http://${aws_eip.eip1.public_ip}/"
}
