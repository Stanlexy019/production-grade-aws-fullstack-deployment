resource "aws_subnet" "private_appsubnet_az1" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "${var.production_vpc}-private-app-az1"
  }
}

resource "aws_subnet" "private_appsubnet_az2" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "${var.production_vpc}-private-app-az2"
  }
}



resource "aws_subnet" "private_dbsubnet_az1" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "${var.production_vpc}-private-db-az1"
  }
}

resource "aws_subnet" "private_dbsubnet_az2" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "${var.production_vpc}-private-db-az2"
  }
}
