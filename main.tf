provider "aws" {
  region = var.region
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for ${var.project_name}"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "${var.project_name}-instance"
  }
}

resource "aws_security_group" "import_demo" {
  name        = "manual-import-demo"
  description = "Manual SG for Import Demo"

  tags = {
    Name = "manual-import-demo"
  }
}
