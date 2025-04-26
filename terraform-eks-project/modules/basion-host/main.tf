
resource "aws_instance" "bastion_host" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  user_data = var.user_data
  tags = {
    Name = var.name
  }
    # iam_instance_profile = aws_iam_instance_profile.bastion_profile.name 
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Security Group for Bastion Host"
  vpc_id      = var.vpc_id
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = {
    Name = "bastion_sg"
  }
}





#     resource "aws_iam_policy" "eks_admin_policy" {
#   name        = "eks-bastion-admin-policy"
#   description = "Full EKS + EC2 NodeGroup access for Bastion"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "eks:Describe*",
#           "eks:List*",
#           "eks:AccessKubernetesApi",
#           "eks:UpdateNodegroupConfig",
#           "eks:UpdateClusterConfig",
#           "autoscaling:Describe*",
#           "autoscaling:UpdateAutoScalingGroup",
#           "ec2:DescribeInstances",
#           "ec2:DescribeTags",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeNetworkInterfaces",
#           "eks:CreateNodegroup"  
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }




# resource "aws_iam_role_policy_attachment" "attach_policy" {
#   role       = aws_iam_role.bastion_role.name
#   policy_arn = aws_iam_policy.eks_admin_policy.arn
# }

# resource "aws_iam_instance_profile" "bastion_profile" {
#   name = "eks-bastion-profile"
#   role = aws_iam_role.bastion_role.name
# }
