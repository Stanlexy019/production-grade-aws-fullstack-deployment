resource "aws_lb_target_group" "app_tg" {
  name     = "${var.lower-case-and-hyphen}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_main_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.production_vpc}_tg"
  }
}
