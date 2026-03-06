resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.production_vpc}-lt-"
  image_id      = "ami-0fa91bc90632c73c9" # Replace with valid AMI in eu-north-1
  instance_type = "t3.micro"
  iam_instance_profile {
  name = aws_iam_instance_profile.production_grade_instance_profile.name
}

 network_interfaces {
  associate_public_ip_address = true
  security_groups             = [aws_security_group.app_sg.id]
}

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e

# Update system
sudo apt update -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Install AWS CLI v2
sudo apt install unzip -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install


# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose



# Ensure SSM agent is installed & running
sudo apt install -y amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Fetch secrets from SSM Parameter Store
JWT_SECRET=$(aws ssm get-parameter \
  --name "/production-grade-aws-fullstack/jwt_secret" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region eu-north-1)

MONGO_URI=$(aws ssm get-parameter \
  --name "/production-grade-aws-fullstack/mongo_uri" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region eu-north-1)

# Save secrets to .env file
cat <<EOT > /home/ubuntu/.env
JWT_SECRET=$JWT_SECRET
MONGO_CONN_STR=$MONGO_URI
EOT

# Login to ECR
aws ecr get-login-password --region eu-north-1 | \
docker login --username AWS --password-stdin 969759464709.dkr.ecr.eu-north-1.amazonaws.com
EOF
  )
          

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.production_vpc}-app-instance"
    } 
  }

}
