
# control plane
# IAM role for EKS control plane
resource "aws_iam_role" "eks_cluster" {
    # Name of the IAM Role
  name = "eks-cluster-role"

    # The policy that grants an entity permission to assume the role.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# Resource: aws_iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
    # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    # The role the policy should be applied to
  role = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name = var.cluster_name

  role_arn = aws_iam_role.eks_cluster.arn


version = "1.30"


  vpc_config {

    endpoint_private_access = false

    endpoint_public_access = true

    subnet_ids = [
        # Use the private subnets created in the VPC module
        var.subnet_ids[0],
        var.subnet_ids[1],
        var.subnet_ids[2],

    ]
  }
access_config{
    authentication_mode ="API"
    bootstrap_cluster_creator_admin_permissions =true
}   
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}

