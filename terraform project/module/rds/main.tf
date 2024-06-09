# main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_db_instance" "rds" {
  identifier          = "free-tier-db-instance"
  allocated_storage    = var.db_allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  db_name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}


resource "aws_security_group" "sg" {
  name        = "rds-sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "run_sql" {
  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.rds.endpoint} -P 3306 -u ${var.db_username} -p${var.db_password} ${var.db_name} < init.sql
    EOT
  }

  depends_on = [aws_db_instance.rds]
}