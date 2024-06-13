variable "aws_region" {
  default = "ap-south-1"
  description = "aws region name"
  type = string
}

variable "vpc_cidr" {
  default = "192.168.0.0/26"
  description = "cidr block"
  type = string
}

variable "environment" {
  default = "Networking"
  description = "environment department"
  type = string
}

variable "public_subnets_cidr" {
  default = "192.168.0.16/28"
  description = "public subnet cidr"
  type = string
}

variable "private_subnets_cidr" {
  default = "192.168.0.32/28"
  description = "private subnet cidr"
  type = string
}

variable "public_availability_zones" {
  default = "ap-south-1a"
  description = "public subnet availability zone"
  type = string
}

variable "private_availability_zones" {
  default = "ap-south-1b"
  description = "private subnet availability zone"
  type = string
}

