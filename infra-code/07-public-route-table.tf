resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.production_vpc}-public-rt"
  }
}