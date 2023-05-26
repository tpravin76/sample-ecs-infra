provider "aws" {
  region = "us-west-2"
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

module "ecs" {
  source = "../modules/ecs"
  DATADOG_API_KEY = var.DATADOG_API_KEY
  DYNAMODB_ACCESSKEY = var.DYNAMODB_ACCESSKEY
  DYNAMODB_ACCESSSECRET = var.DYNAMODB_ACCESSSECRET
  ES_PRIMARY_PASS = var.ES_PRIMARY_PASS
  ES_PRIMARY_USER = var.ES_PRIMARY_USER
  JWT_SECRET = var.JWT_SECRET
  SF_CLIENT_ID = var.SF_CLIENT_ID
  SF_CLIENT_SECRET = var.SF_CLIENT_SECRET
  SF_PASS = var.SF_PASS
  SF_USER = var.SF_USER
  app_environment = var.app_environment
  app_name = var.app_name
  vpc_id = module.vpc.aws_vpc_id
  private_subnets = module.subnets.aws_subnet_private_id
  public_subnets = module.subnets.aws_subnet_public_id
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  ecsTaskExecutionRoleArn = module.iam.ecsTaskExecutionRoleArn
}

module "vpc" {
  source = "../modules/vpc"
  app_environment = var.app_environment
  app_name = var.app_name
}

module "subnets" {
  source = "../modules/subnets"
  app_environment = var.app_environment
  app_name = var.app_name
  availability_zones = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  vpc_id = module.vpc.aws_vpc_id
  igw = module.vpc.aws_internet_gateway_id
}

module "alerts" {
  source = "../modules/alerts"
  app_environment = var.app_environment
  app_name = var.app_name
  emails = var.emails
}

module "ecr" {
  source = "../modules/ecr"
  app_environment = var.app_environment
  app_name = var.app_name
}

module "iam" {
  source = "../modules/iam"
  app_environment = var.app_environment
  app_name = var.app_name
}
