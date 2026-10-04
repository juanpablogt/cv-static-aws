output "website_url" {
  description = "Public HTTP URL for the CV."
  value       = "http://${aws_s3_bucket.cv.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}

output "bucket_name" {
  description = "Name of the public S3 bucket."
  value       = aws_s3_bucket.cv.bucket
}
