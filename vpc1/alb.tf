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

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    prefix  = "alb"
    enabled = true
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket        = "my-lb-logs-test-play-priv-link"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = data.aws_iam_policy_document.allow_access_from_alb.json
}

data "aws_iam_policy_document" "allow_access_from_alb" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::156460612806:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.alb_logs.arn,
      "${aws_s3_bucket.alb_logs.arn}/*",
    ]
  }
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
