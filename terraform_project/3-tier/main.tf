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

module "alb" {
  source = "./lb"
  vpc_id = module.vpc.vpc_id
  subnetid_1 = module.vpc.private_subnet_id_1
  subnetid_2 = module.vpc.private_subnet_id_2
  security_groups = module.sg.sg_ids 
}

resource "null_resource" "output_value" {
  provisioner "local-exec" {
    command = "terraform output -json > terraform_outputs.json "
  }
  depends_on = [module.rds , module.alb]
}

resource "null_resource" "create_database" {
  provisioner "local-exec" {
    command = "bash ${path.module}/generate_inventory.sh && ansible-playbook -i inventory.ini create_database.yml --ask-vault-pass"
  }
  depends_on = [null_resource.output_value]
}
resource "null_resource" "script_file" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass"
  }
  depends_on = [null_resource.create_database]
}

resource "null_resource" "nginx_setup" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini nginx_setup.yml"
  }
  depends_on = [null_resource.script_file]
}