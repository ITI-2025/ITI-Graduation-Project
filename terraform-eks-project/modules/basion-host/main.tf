
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
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name

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
resource "aws_iam_role" "bastion_role" {
  name = "bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAccessPolicy"
}
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "BastionECRAccessPolicy"
  description = "Allow Bastion host to access Amazon ECR"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
        ],
        Resource = "*"
      }
    ]
  })
}

