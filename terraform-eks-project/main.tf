module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
module "eks"{
    source = "./modules/eks"
    cluster_name = "eks-cluster"
    vpc_id = module.vpc.vpc_id
    subnet_ids = [module.vpc.private_subnet_1, module.vpc.private_subnet_2, module.vpc.private_subnet_3]
   

}
