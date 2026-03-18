resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terraform_main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.production_vpc}-private-rt"
  }
}
