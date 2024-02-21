#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 4.0"
#    }
#  }
##  backend "remote" {
##    organization = "my-org"
##    workspaces {
##      name = "my-workspace"
##    }
##  }
#}

provider "aws" {
  region = "us-east-1"
}