variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "group7-terraform-conformity-bucket-2025"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}