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
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for ${var.project_name} in ${var.environment}"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-sg-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name        = "${var.project_name}-instance-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "import_demo" {
  name        = "manual-import-demo-${var.environment}"
  description = "Manual SG for Import Demo in ${var.environment}"

  tags = {
    Name        = "manual-import-demo-${var.environment}"
    Environment = var.environment
  }
}
