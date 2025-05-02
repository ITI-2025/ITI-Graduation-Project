
# Create IAM role for EKS Node Group
resource "aws_iam_role" "nodes_general" {
  name = "eks-node-group-role-general"

  # The policy that grants an entity permission to assume the role.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.nodes_general.name
}


#  
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  role = aws_iam_role.nodes_general.name
}



resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

  role = aws_iam_role.nodes_general.name
}


resource "aws_eks_node_group" "nodes_general" {
  cluster_name =var.cluster_name

  node_group_name = "nodes-general"

  node_role_arn = aws_iam_role.nodes_general.arn

  subnet_ids = [

   
    var.subnet_ids[0],
    var.subnet_ids[1],
    var.subnet_ids[2],
     
      
  ]

  scaling_config {
    desired_size = 1

    max_size = 1

    min_size = 1
  }

  
   ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 20

  force_update_version = false

  instance_types = ["t3.medium"]
  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "nodes-general"
  } 


  # Kubernetes vesion
  version = "1.30"
  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_full_access,
  ]

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
     
    ]
  }
}