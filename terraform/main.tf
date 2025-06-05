provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    terraform = "true"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "static_s3" {
  bucket              = var.bucket_name
  object_lock_enabled = false


  tags = merge(local.common_tags, {
    Name = "ahmed_elhgawy_static_website"
  })
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.static_s3.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.static_s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.static_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "S3_website" {
  bucket = aws_s3_bucket.static_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.static_s3.id
  policy = data.aws_iam_policy_document.allow_access_from_any.json
}

data "aws_iam_policy_document" "allow_access_from_any" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.static_s3.arn}/*",
    ]
  }
}
