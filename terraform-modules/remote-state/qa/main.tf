provider "aws" {
  region = "us-west-2"
}

module "backend" {
  source = "../modules"
  app_environment = var.app_environment
  app_name = var.app_name
  aws_region = var.aws_region
  bucket_name_prefix = var.bucket_name_prefix
}
