variable "region" {
  type        = string
  description = "The AWS region to deploy resources in"
}

variable "bucket_name" {
  type = string
  description = "The Bucket Name (Must be a unique name)"
}
