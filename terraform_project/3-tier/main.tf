provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./vpc" 
  vpc_cidr = "192.168.0.0/16"
  environment = "Networking"
  public_subnets_cidr = "192.168.1.0/24"
  private_subnets_1_cidr = "192.168.2.0/24"
  private_subnets_2_cidr = "192.168.3.0/24"
  public_availability_zones = "us-east-2a"
  private_1_availability_zones = "us-east-2b"
  private_2_availability_zones = "us-east-2c"
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
  private_subnet_id = module.vpc.private_subnet_id_1
  environment = "production"
  sg_id = module.sg.sg_ids 
}

module "rds" {
  source = "./rds"
  vpc_id = module.vpc.vpc_id
  subnetid_1 = module.vpc.private_subnet_id_1
  subnetid_2 = module.vpc.private_subnet_id_2
  storage = "20"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  db_username = "admin"
  db_password = "admin123"
}

output "rds_endpoint"{
  value = module.rds.rds_endpoint
}
output "subnet_id_1" {
  value = module.vpc.private_subnet_id_1
}

output "subnet_id_2" {
  value = module.vpc.private_subnet_id_2
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

resource "null_resource" "rds_access" {
  provisioner "local-exec" {
    command = "ssh -L 3336:'${rds_endpoint}':3306 ubuntu@'${public_instance_public_ip}' -N -f && 
    lsof -i4 -P | grep -i 'listen' | grep 3336 &&
    nc -zv 127.0.0.1 3336 && mysql -h 127.0.0.1 -P 3336 -u '${module.rds.username}' -p'${module.rds.password}'"
  }
  depends_on = [module.rds]
}