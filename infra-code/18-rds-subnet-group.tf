resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.production_vpc}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_dbsubnet_az1.id,
    aws_subnet.private_dbsubnet_az2.id
  ]

  tags = {
    Name = "${var.production_vpc}-db-subnet-group"
  }
}
