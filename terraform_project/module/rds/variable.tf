# variables.tf

variable "db_name" {
  default = "studentapp"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "admin123"
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "aws_region" {
  default = "us-east-1"
}
