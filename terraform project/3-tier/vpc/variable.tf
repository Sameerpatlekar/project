variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "192.168.0.0/26"
}

variable "environment" {
  default = "Networking"
}

variable "public_subnets_cidr" {
  default = "192.168.0.16/28"
}

variable "private_subnets_cidr" {
  default = "192.168.0.32/28"
}

variable "public_availability_zones" {
  default = "ap-south-1a"
}

variable "private_availability_zones" {
  default = "ap-south-1b"
}

