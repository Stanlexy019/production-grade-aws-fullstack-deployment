resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform_main_vpc.id

  tags = {
    Name = "${var.production_vpc}-internet-gw"
  }
}