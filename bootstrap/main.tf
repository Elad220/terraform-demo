provider "aws" {
  region = "us-east-1"
}

variable "project_name" {
  description = "Name of the project to prefix resources"
  type        = string
  default     = "terraform-experiments"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-state-bucket-${random_id.bucket_suffix.hex}"

  # Prevent accidental deletion of this S3 bucket
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project_name}-running-locks"
  billing_mode = "PROVISIONED"
  # Free tier includes 25 WCU and 25 RCU
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
