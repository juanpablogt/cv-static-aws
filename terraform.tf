terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "cv" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "cv" {
  bucket = aws_s3_bucket.cv.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "cv" {
  bucket = aws_s3_bucket.cv.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "cv" {
  bucket = aws_s3_bucket.cv.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.cv.id

  depends_on = [aws_s3_bucket_public_access_block.cv]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.cv.arn}/*"
    }]
  })
}

locals {
  site_files = {
    "index.html" = {
      content_type = "text/html"
    }
    "style.css" = {
      content_type = "text/css"
    }
    "script.js" = {
      content_type = "application/javascript"
    }
  }
}

resource "aws_s3_object" "site_files" {
  for_each = local.site_files

  bucket       = aws_s3_bucket.cv.id
  key          = each.key
  source       = "${path.module}/${each.key}"
  content_type = each.value.content_type
  etag         = filemd5("${path.module}/${each.key}")
}
