# Terraform Experiments

A modular Terraform project for deploying AWS infrastructure with remote state management, multiple environments, and reusable modules.

## Directory Structure

```
.
├── bootstrap/          # Remote state backend setup (S3 + DynamoDB)
├── environments/       # Environment-specific configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/            # Reusable Terraform modules
│   ├── compute/
│   ├── eks/
│   └── vpc/
├── main.tf            # Root module configuration
├── variables.tf       # Root module variables
└── backend.tf         # Remote state configuration
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- AWS account with appropriate permissions

## Quick Start

### 1. Bootstrap Remote State

First, set up the S3 bucket and DynamoDB table for remote state:

```bash
cd bootstrap
terraform init
terraform apply
```

Note the output values for `s3_bucket_name` and `dynamodb_table_name`.

### 2. Deploy an Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Modules

| Module | Description |
|--------|-------------|
| `vpc` | Creates a VPC with subnets |
| `compute` | EC2 instances and security groups |
| `eks` | Amazon EKS cluster configuration |

## Remote State

This project uses S3 for state storage and DynamoDB for state locking. The bootstrap module creates these resources:

- **S3 Bucket**: Stores Terraform state files with versioning and encryption
- **DynamoDB Table**: Provides state locking to prevent concurrent modifications

## License

MIT
