module "vpc" {
  source = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

module "my-eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"
  enable_irsa = true
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.31"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  cluster_endpoint_public_access = false
  cluster_endpoint_private_access = true
  # node_groups = {
  #   eks_nodes = {
  #     desired_capacity = 2
  #     max_size         = 3
  #     min_size         = 1
  #     instance_type   = "t3.medium"
  #     key_name        = "basion-key-2"
  #   }
  # } 

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
  key_name          = "basion-key-2"
  security_group_ids = module.vpc.basion_sg
  user_data         = file("user-data.sh")
  name              = "my-basion-host"

  
}
