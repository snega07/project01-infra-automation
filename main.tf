module "networking" {
  source = "./modules/networking"
  vpc_cidr        = var.vpc_cidr
  public_subnet   = var.public_subnet
  private_subnet  = var.private_subnet
  rds_subnet      = var.rds_subnet

}