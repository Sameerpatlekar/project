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

module "rds" {
  source = "./rds"
  storage = "20"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  db_username = "admin"
  db_password = "admin123"
  subnetid_1 = module.vpc.private_subnet_id
  subnetid_2 = module.vpc.private_subnet_id
}

  
}
output "subnet_id" {
  value = module.vpc.private_subnet_id
}
output "public_instance_public_ip" {
  value = module.ec2.public_instance_public_ip
}

output "private_instance_private_ip" {
  value = module.ec2.private_instance_private_ip
}

resource "null_resource" "script_file" {
  provisioner "local-exec" {
    command = "bash ${path.module}/generate_inventory.sh && ansible-playbook -i inventory.ini playbook.yml"
  }
  depends_on = [module.vpc]
}

