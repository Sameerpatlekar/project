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

module "sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

module "key" {
  source = "./key-pair"
  key_name = "my-project-key"
}

module "ec2" {
  source = "./ec2"
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  environment = "production"
  key_name = module.key.key_name
  sg_id = module.sg.sg_id
}