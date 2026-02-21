provider "aws" {
  region = var.region
}

module "compute" {
  source        = "../../modules/compute"
  region        = var.region
  instance_type = var.instance_type
  project_name  = var.project_name
  environment   = var.environment
}

module "vpc" {
  source          = "../../modules/vpc"
  count           = var.enable_vpc ? 1 : 0
  name            = "${var.project_name}-vpc-${var.environment}"
  cidr            = var.vpc_cidr
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "eks" {
  source          = "../../modules/eks"
  count           = var.enable_eks ? 1 : 0
  cluster_name    = "${var.project_name}-eks-${var.environment}"
  cluster_version = "1.29"
  vpc_id          = module.vpc[0].vpc_id
  subnet_ids      = module.vpc[0].private_subnets
  instance_types  = var.eks_instance_types
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
