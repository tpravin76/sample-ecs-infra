provider "aws" {
  region = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    key    = "state/terraform_state.tfstate"
  }
}

module "s3" {
  source = "../modules/s3"
  app_environment = var.app_environment
  app_name = var.app_name
}
module "cloudfront" {
  source = "../modules/cloudfront"
  app_environment = var.app_environment
  app_name = var.app_name
  domain_name = var.domain_name
  hosted_zone = var.hosted_zone
  s3_arn = module.s3.aws_s3_bucket_arn
  s3_id = module.s3.aws_s3_bucket_id
  aws_s3_bucket_domain_name = module.s3.aws_s3_bucket_domain_name
}