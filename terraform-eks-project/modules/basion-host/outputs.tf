

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "instance_id" {
  value = aws_instance.bastion_host.id
}

output "private_ip" {
  value = aws_instance.bastion_host.private_ip
}
output "public_ip" {
  value = aws_instance.bastion_host.public_ip
}

