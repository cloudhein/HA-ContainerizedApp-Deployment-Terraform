variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
  default     = "remote-state-bucket-dev-003"
}

variable "aws_region" {
  type        = string
  description = "The name of the AWS region"
  default     = "ap-northeast-1"
}

variable "profile" {
  type        = string
  description = "The name of the AWS profile"
  default     = "terraform-dev-role"
}