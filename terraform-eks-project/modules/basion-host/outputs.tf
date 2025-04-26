
# output "instance_id" {
#   value = aws_instance.basion-host.id
# }

# output "public_ip" {
#   value = aws_instance.basion-host.public_ip
# }


# output "bastion_private_ip" {
#   value = aws_instance.basion-host.private_ip
# }
# output "private_ip" {
#   value = aws_instance.bastion-host.private_ip
# }

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "instance_id" {
  value = aws_instance.bastion_host.id
}

output "private_ip" {
  value = aws_instance.bastion_host.private_ip
}
