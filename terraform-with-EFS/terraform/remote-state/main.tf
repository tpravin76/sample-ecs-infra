provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state_pravin" {
  bucket = "sample-pravin-tfstate" # has to be unique

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_pravin" {
  bucket = aws_s3_bucket.terraform_state_pravin.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}