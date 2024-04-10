output "private_key_file" {
  value       = local_file.private_key.filename
  description = "pem file"
}

output "aws_instance" {
  value = aws_instance.web_server.public_dns
  description = "public dns"
}

output "aws_instance" {
  value = aws_instance.web_server.public_ip
  description = "public ip"
}