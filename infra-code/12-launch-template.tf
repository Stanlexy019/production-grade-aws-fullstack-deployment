resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.production_vpc}-lt-"
  image_id      = "ami-0fa91bc90632c73c9" # Replace with valid AMI in eu-north-1
  instance_type = "t3.micro"
  iam_instance_profile {
  name = aws_iam_instance_profile.production_grade_instance_profile.name
}

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "Hello from Production App" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.production_vpc}-app-instance"
    }

    
  }

  

}
