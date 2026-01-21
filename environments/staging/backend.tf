terraform {
  backend "s3" {
    bucket         = "terraform-experiments-state-bucket-3dfb41fa"
    key            = "envs/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-experiments-running-locks"
    encrypt        = true
  }
}
