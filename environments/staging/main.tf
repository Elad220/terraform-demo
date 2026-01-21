provider "aws" {
  region = var.region
}

module "compute" {
  source = "../../modules/compute"

  region        = var.region
  instance_type = var.instance_type
  project_name  = var.project_name
  environment   = "staging"
}
