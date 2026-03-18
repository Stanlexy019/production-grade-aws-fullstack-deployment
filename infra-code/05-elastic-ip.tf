resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.production_vpc}-nat-eip"
  }
}
