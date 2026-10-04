variable "aws_region" {
  description = "AWS region where the S3 website will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique public S3 bucket name, for example juan-pablo-cv-2026."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be a valid S3 bucket name between 3 and 63 characters."
  }
}

variable "tags" {
  description = "Tags applied to the S3 bucket."
  type        = map(string)
  default = {
    Project   = "cv-static"
    ManagedBy = "Terraform"
  }
}
