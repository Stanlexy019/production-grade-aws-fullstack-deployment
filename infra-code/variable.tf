variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}


variable "production_vpc" {
  description = "Name of the production VPC"
  type        = string
  default     = "aspire_vpc"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "lower-case-and-hyphen" {
  description = "Lower case and hyphen version of the production VPC name"
  type        = string
  default     = "aspire-vpc"
}