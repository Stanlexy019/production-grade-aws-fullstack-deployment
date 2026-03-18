resource "aws_lb" "app_alb" {
  name               = "${var.lower-case-and-hyphen}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_subnet_az1.id,
    aws_subnet.public_subnet_az2.id
  ]

  tags = {
    Name = "${var.production_vpc}_alb"
  }
}
