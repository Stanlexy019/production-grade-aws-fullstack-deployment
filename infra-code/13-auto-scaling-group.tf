resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.main_subnet1.id,
    aws_subnet.main_subnet2.id
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "${var.production_vpc}-app-asg"
    propagate_at_launch = true
  }
}
