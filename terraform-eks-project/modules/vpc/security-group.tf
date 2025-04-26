# resource "aws_security_group" "basion_sg" {
#   name        = "basion-sg"
#   description = "Allow inbound traffic for EC2 instances"
#     vpc_id      = aws_vpc.this.id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Open SSH to all IPs
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Open HTTP to all IPs
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Open HTTPS to all IPs
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
#   }

#   tags = {
#     Name = "ec2_sg"
#   }
# }
# resource "aws_security_group" "bastion_sg" {
#   name        = "bastion_sg"
#   description = "Security Group for Bastion Host"
#   vpc_id      = aws_vpc.this.id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }

#   tags = {
#     Name = "bastion_sg"
#   }
# }
