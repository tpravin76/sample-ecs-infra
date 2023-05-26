provider "aws" {
  region = "us-east-1"
}

module "backend" {
  source = "../modules"
  app_environment = var.app_environment
  app_name = var.app_name
  aws_region = var.aws_region
}
