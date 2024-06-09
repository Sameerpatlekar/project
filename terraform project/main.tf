provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami                    = "ami-0f0efa3f97e6a443f"
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



