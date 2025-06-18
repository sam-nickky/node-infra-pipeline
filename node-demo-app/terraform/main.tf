module "vpc" {
  source = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "rds" {
  source = "./modules/rds"
  vpc_id     = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids         
  ec2_sg_id          = module.ec2.instance_sg_id 
 
  db_name     = "nodeapp"
  db_username = "dbadmin"
  db_password = "SaMAkkina!223"
}

module "alb" {
  source = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_group_port = 3000
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  instance_profile = module.iam.instance_profile
  alb_sg_id            = module.alb.security_group_id
}
