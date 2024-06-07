provider "aws" {
  region     = "us-east-1"

}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # This means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-security-group"
  }
}

resource "aws_instance" "ec2" {
  ami                    = "ami-073f8d21389408eb4"
  instance_type          = "t2.micro"
  key_name               = "pub-key"
  vpc_security_group_ids = [aws_security_group.example.id]

  provisioner "remote-exec" {
    inline = [
      "sudo bash /root/apache/bin/catalina.sh start"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}   

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  default     = "/home/sameer/.ssh/id_rsa"  # Adjust this path to match your private key's location
}