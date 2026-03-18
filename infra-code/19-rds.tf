resource "aws_db_instance" "app_db" {
  identifier             = "${var.lower-case-and-hyphen}-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = "Admin12345!"
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "${var.production_vpc}_rds"
  }
}
