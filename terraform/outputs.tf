output "EC2_PUBLIC_IP" {
  description = "Public IP of Grandel EC2 server"
  value       = aws_instance.grandel_server.public_ip
}

output "EC2_PUBLIC_DNS" {
  description = "Public DNS of Grandel EC2 server"
  value       = aws_instance.grandel_server.public_dns
}

output "ssh_command" {
  description = "Command to SSH into the server"
  value       = "ssh -i fa1-key.pem ubuntu@${aws_instance.grandel_server.public_ip}"
}

output "app_url" {
  description = "URL to access Grandel"
  value       = "http://${aws_instance.grandel_server.public_ip}"
}
