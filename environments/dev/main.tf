provider "aws" {
  region = var.region
}

module "compute" {
  source = "../../modules/compute"

  region        = var.region
  instance_type = var.instance_type
  project_name  = var.project_name
  environment   = "dev"
}

module "vpc" {
  source = "../../modules/vpc"

  name = "${var.project_name}-vpc-dev"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "dev-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  instance_types = ["t3.small"]

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}
