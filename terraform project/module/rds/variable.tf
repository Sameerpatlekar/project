variable "region" {
  description = "The AWS region to deploy in"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The VPC ID to deploy into"
}

variable "subnet_ids" {
  description = "A list of subnet IDs to deploy into"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name to use for EC2 instances"
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
}

variable "db_username" {
  description = "The database admin username"
  default = "admin"
}

variable "db_password" {
  description = "The database admin password"
  sensitive   = true
  default = "admin123"
}

variable "db_name" {
  description = "The database name"
  default     = "myrds"
}
