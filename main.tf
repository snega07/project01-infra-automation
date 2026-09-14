module "networking" {
  source = "./modules/networking"
  vpc_cidr        = var.vpc_cidr
  public_subnet   = var.public_subnet
  private_subnet  = var.private_subnet
  rds_subnet      = var.rds_subnet
  enable_nat = true
  single_nat = false
  tags = var.tags 

}

module "iam" {
  source = "./modules/iam"
  tags = var.tags
  cluster_name = "project01-cluster"
}

module "eks-cluster" {
  source = "./modules/eks-cluster"
  cluster_name = "project01-cluster"
  tags = var.tags
  node_role_arn = module.iam.node_role_arn
  cluster_role_arn = module.iam.cluster_role_arn
  subnet_ids = module.networking.private_subnet_ids
  kubernetes_version = 1.36
  endpoint_public_access = true
  endpoint_private_access = true
  public_access_cidrs = ["0.0.0.0/0"]
  vpc_id = module.networking.vpc_id

  node_groups = {
    on_demand = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      labels         = { "role" = "worker" }
      taints         = []
      tags           = { "Name" = "node-group-1" }
    }
  }
}