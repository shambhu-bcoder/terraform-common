resource "aws_instance" "web_server" {
  ami           = "ami-0914547665e6a707c" # Update with desired Ubuntu AMI 22.04 LTS
  instance_type = "t3.medium"
  key_name      = aws_key_pair.key_pair.key_name
  associate_public_ip_address = false
  monitoring = true
  vpc_security_group_ids      = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "mytuur-prod"
  }
 provisioner "file" {
  source       = "${path.module}/mytuur.conf"
  destination  = "/home/ubuntu/default.conf"
}
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.rsa_4096.private_key_pem
      host        = self.public_ip
    }
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
    "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    "sudo apt-get update",
    "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
    "sudo apt-get install -y software-properties-common",
    "sudo add-apt-repository -y ppa:nginx/stable",
    "sudo apt-get install -y nginx",
    "sudo systemctl start nginx",
    "sudo systemctl enable nginx",
    "sudo mv /home/ubuntu/default.conf /etc/nginx/sites-enabled/mytuur",
    "sudo systemctl reload nginx",
     "sudo docker network create mytuur",
     "sudo docker pull mongo",
     "sudo docker run -d --name mongo -p 27017:27017 --network mytuur -v /data:/data/db -e MONGO_INITDB_ROOT_USERNAME=${var.mongodb_username} -e MONGO_INITDB_ROOT_PASSWORD=${var.mongodb_password} -it mongo:latest",
     "sudo docker pull shambhubcoder44/mytuur:latest",
    //3023 port also added in nginx script i.e mytuur.conf
    "sudo docker run -d --name mytuur -p 3023:3023   --network mytuur shambhubcoder44/mytuur:latest ",
  ]
}

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = "touch inventory.ini"
  }
}

