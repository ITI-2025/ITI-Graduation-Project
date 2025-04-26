module "vpc" {
  source = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}



resource "aws_security_group" "eks_api_sg" {
  name        = "eks-api-sg"
  description = "Allow Bastion Host to access EKS API"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${module.ec2_instance.private_ip}/32"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = {
    Name = "eks-api-sg"
  }
}
module "my-eks" {
  source  = "terraform-aws-modules/eks/aws"
  # version = "~> 20.31"
   version = "19.0.0" 
  enable_irsa = true
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.31"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
    cluster_security_group_id = aws_security_group.eks_api_sg.id

  tags = {
    Name = "my-eks-cluster"
  } 


 eks_managed_node_groups = {
   example = {

     instance_types = ["t3.medium"]

     min_size       = 1

     max_size       = 3

     desired_size   = 2

   }
 }
}

module "ec2_instance" {
  source = "./modules/basion-host"
  ami_id = "ami-0ff8a91507f77f867"  
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.public_subnet_ids[0]
  vpc_id           = module.vpc.vpc_id
  key_name          = "basion-key-2"
  user_data         = file("user-data.sh")
  name              = "my-basion-host"
}
