resource "aws_vpc" "terraform_main_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.production_vpc
  }
}