provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./vpc" 
  aws_region = "ap-south-1"
  vpc_cidr = "192.168.0.0/26"
  environment = "Networking"
  public_subnets_cidr = "192.168.0.16/28"
  private_subnets_cidr = "192.168.0.32/28"
  public_availability_zones = "ap-south-1a"
  private_availability_zones = "ap-south-1b"
}
