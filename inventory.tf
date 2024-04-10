data "template_file" "inventory" {
  template = <<-EOT
[ec2_instances]
${aws_instance.web_server.public_ip} ansible_user=ubuntu ansible_private_key_file=${path.module}/${aws_key_pair.key_pair.key_name}.pem
EOT
}
resource "local_file" "inventory" {
  depends_on = [aws_instance.web_server]
  filename   = "inventory.ini"
  content    = data.template_file.inventory.rendered

  provisioner "local-exec" {
    command = "chmod 400 ${self.filename}"
  }
}