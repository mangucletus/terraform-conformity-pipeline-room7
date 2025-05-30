variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-terraform-conformity-test-bucket-12345"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}