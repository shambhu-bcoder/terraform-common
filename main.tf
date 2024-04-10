provider "aws" {
  region = "eu-north-1"
 
  # Use environment variables or a secure secrets management system for access keys
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "${aws_key_pair.key_pair.key_name}.pem"

  provisioner "local-exec" {
    command = "chmod 400 ${aws_key_pair.key_pair.key_name}.pem"
  }
}

resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "web_server_ip" {
  depends_on = [aws_security_group.sg_ec2]
}




resource "aws_eip_association" "web_server_association" {
  allocation_id = aws_eip.web_server_ip.id
  instance_id   = aws_instance.web_server.id
}

//Ansible script not working
# resource "null_resource" "run_ansible" {
#    depends_on = [local_file.inventory, aws_instance.web_server,]

#    provisioner "local-exec" {
#      command     = "ansible-playbook -i inventory.ini ${path.module}/mongodb.yml"
#      working_dir = path.module
#    }
#  }
