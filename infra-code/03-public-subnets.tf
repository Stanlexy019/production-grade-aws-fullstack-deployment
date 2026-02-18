resource "aws_subnet" "main_subnet1" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "${var.production_vpc}-public-subnet-az1"
  }
}

resource "aws_subnet" "main_subnet2" {
  vpc_id            = aws_vpc.terraform_main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "${var.production_vpc}-public-subnet-az2"
  }
}