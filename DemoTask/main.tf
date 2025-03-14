#configure aws provider
provider "aws"{
    region  = var.region
    #profile = "terraform user"
}

# create vpc
module "vpc" {
source                          = "../modules/vpc"
region                          = var.region
project_name                    = var.project_name
vpc_cidr                        = var.vpc_cidr
public_subnet_az1_cidr          = var.public_subnet_az1_cidr
public_subnet_az2_cidr          = var.public_subnet_az2_cidr
private_app_subnet_az1_cidr     = var.private_app_subnet_az1_cidr
private_app_subnet_az2_cidr     = var.private_app_subnet_az2_cidr
private_data_subnet_az1_cidr    = var.private_data_subnet_az1_cidr 
private_data_subnet_az2_cidr    = var.private_data_subnet_az2_cidr 
}

module"security-group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
} 

module"application_load_balancer" {
source            = "../modules/alb"
project_name      = module.vpc.project_name 
alb-sg-id         = module.security-group.alb-sg-id
public_subnet_az1 = module.vpc.public_subnet_az1
public_subnet_az2 = module.vpc.public_subnet_az2
vpc_id            = module.vpc.vpc_id
} 


#Autoscaling submodule being used
 module "autoscaling" {
source               = "../modules/asg"
project_name         = module.vpc.project_name
ec2-sg-id            = module.security-group.ec2-sg-id
public_subnet_az1    = module.vpc.public_subnet_az1
public_subnet_az2    = module.vpc.public_subnet_az2
#alb-id               = module.application_load_balancer.alb-id
alb_target_group = module.application_load_balancer.alb_target_group
}

module "rds" {
source                    = "../modules/rds"
vpc_id                    = module.vpc.vpc_id
ec2-sg-id                 = module.security-group.ec2-sg-id
private_data_subnet_az1   = module.vpc.private_data_subnet_az1_id
private_data_subnet_az2   = module.vpc.private_data_subnet_az2_id
}