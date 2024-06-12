variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "environment" {
  default = "production"
}

variable "public_subnets_cidr" {
  default = "10.0.0.0/24"
}

variable "public_availability_zones" {
  default = "ap-south-1a"
}

variable "private_availability_zones" {
  default = "ap-south-1b"
}

