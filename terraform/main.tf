# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# S3 bucket resource (intentionally insecure for testing)
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "Example Bucket"
    Environment = var.environment
  }
}

# This will trigger security findings
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false  # Security issue
  block_public_policy     = false  # Security issue  
  ignore_public_acls      = false  # Security issue
  restrict_public_buckets = false  # Security issue
}