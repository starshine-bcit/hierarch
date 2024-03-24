output "admin_ipv4" {
  value = aws_eip.admin_ip.public_ip
}

output "admin_ipv6" {
  value = element(aws_instance.admin.ipv6_addresses, 0)
}

output "mail_ipv4" {
  value = aws_eip.mail_ip.public_ip
}

output "mail_ipv6" {
  value = element(aws_instance.mail.ipv6_addresses, 0)
}

output "app_ipv4" {
  value = aws_eip.app_ip.public_ip
}

output "app_ipv6" {
  value = element(aws_instance.app.ipv6_addresses, 0)
}

output "ssh_user_name" {
  value = "admin"
}

output "ssh_key_file" {
  value = aws_key_pair.local_key.key_name
}
