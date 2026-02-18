# Public route table associations
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.main_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.main_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# private db route table associations
resource "aws_route_table_association" "db_rt_assoc_az1" {
  subnet_id      = aws_subnet.private_dbsubnet_az1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_rt_assoc_az2" {
  subnet_id      = aws_subnet.private_dbsubnet_az2.id
  route_table_id = aws_route_table.private_rt.id
}

# private app route table associations
resource "aws_route_table_association" "app_rt_assoc_az1" {
  subnet_id      = aws_subnet.private_appsubnet_az1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "app_rt_assoc_az2" {
  subnet_id      = aws_subnet.private_appsubnet_az2.id
  route_table_id = aws_route_table.private_rt.id
}