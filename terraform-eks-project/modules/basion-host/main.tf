
resource "aws_instance" "basion-host" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_ids]
  user_data = var.user_data
  tags = {
    Name = var.name
  }
    iam_instance_profile = aws_iam_instance_profile.bastion_profile.name 
}
resource "aws_iam_role" "bastion_role" {
  name = "eks-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_admin_policy" {
  name        = "eks-bastion-admin-policy"
  description = "Full EKS + EC2 NodeGroup access for Bastion"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:Describe*",
          "eks:List*",
          "eks:AccessKubernetesApi",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateClusterConfig",
          "autoscaling:Describe*",
          "autoscaling:UpdateAutoScalingGroup",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeNetworkInterfaces"
        ],
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "eks-bastion-profile"
  role = aws_iam_role.bastion_role.name
}
