provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./vpc" 
  vpc_cidr = "192.168.0.0/26"
  environment = "Networking"
  public_subnets_cidr = "192.168.0.16/28"
  private_subnets_cidr = "192.168.0.32/28"
  public_availability_zones = "us-east-2a"
  private_availability_zones = "us-east-2b"
}

module "sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./ec2"
  ami = "ami-09040d770ffe2224f"
  instance_type = "t2.micro"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  environment = "production"
  sg_id = module.sg.sg_ids
}

resource "null_resource" "copy_ip" {
  provisioner "local-exec" {
    command = <<EOT
      "echo ${module.ec2.public_instance_public_ip} > ip.txt"
    EOT
  }
}

