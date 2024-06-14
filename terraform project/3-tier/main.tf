provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./vpc" 
  vpc_cidr = "192.168.0.0/26"
  environment = "Networking"
  public_subnets_cidr = "192.168.0.16/28"
  private_subnets_cidr = "192.168.0.32/28"
  public_availability_zones = "us-east-1a"
  private_availability_zones = "us-east-1b"
}

module "sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./ec2"
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  environment = "production"
  key_name = module.key.key_name
  sg_id = module.sg.sg_ids
}

resource "null_resource" "ansible_playbook" {
  provisioner "local-exec" {
    command = <<EOT
      ./generate_inventory.sh
      ansible-playbook -i inventory.ini playbook.yml
    EOT
  }

  depends_on = [aws_instance.frontend, aws_instance.backend]
}