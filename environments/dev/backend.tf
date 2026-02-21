terraform {
  backend "s3" {
    bucket       = "terraform-experiments-state-bucket-3dfb41fa"
    key          = "environments/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
