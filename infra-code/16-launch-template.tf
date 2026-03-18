resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.production_vpc}-lt-"
  image_id      = "ami-0fa91bc90632c73c9" # Replace with valid AMI in eu-north-1
  instance_type = "t3.micro"
  iam_instance_profile {
    name = aws_iam_instance_profile.production_grade_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
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

cat <<EOR > /home/ubuntu/docker-compose.yml
version: "3.8"

services:

  mongo:
    image: mongo:6
    container_name: mongo
    volumes:
      - mongo_data:/data/db

  backend:
    image: 969759464709.dkr.ecr.eu-north-1.amazonaws.com/production-grade-aws-fullstack-backend:v1
    env_file:
      - /home/ubuntu/.env
    depends_on:
      - mongo
    ports:
      - "3500:3500"

  frontend:
    image: 969759464709.dkr.ecr.eu-north-1.amazonaws.com/production-grade-aws-fullstack-frontend:v1
    ports:
      - "80:80"

volumes:
  mongo_data:
EOR

sleep 20
cd /home/ubuntu
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 969759464709.dkr.ecr.eu-north-1.amazonaws.com
docker-compose pull
docker-compose up -d

EOF
  )


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.production_vpc}-app-instance"
    }
  }

}
