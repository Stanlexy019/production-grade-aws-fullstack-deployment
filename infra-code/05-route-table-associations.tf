# Public route table associations
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.main_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.main_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}


