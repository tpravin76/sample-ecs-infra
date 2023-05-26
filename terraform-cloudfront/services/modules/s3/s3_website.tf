# create S3 Bucket:
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.app_name}-${var.app_environment}-static-content"
  force_destroy = true
  tags = {
    Name        = var.app_name
    Environment = var.app_environment
  }
}
resource "aws_s3_bucket_ownership_controls" "oc" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
# create bucket ACL :
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.oc]
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
# block public access :
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
# encrypt bucket using SSE-S3:
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# create S3 website hosting:
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}
output "aws_s3_bucket_id" {
  value = aws_s3_bucket.bucket.id
}
output "aws_s3_bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}