terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "minimal" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t2.micro"
  tags = {
    Name = "minimal-instance"
  }
}