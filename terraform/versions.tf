terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Configure remote state (optional but recommended)
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "terraform/state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}