output "private_key_file" {
  value       = local_file.private_key.filename
  description = "pem file"
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
  description = "public dns"
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
  description = "public ip"
}