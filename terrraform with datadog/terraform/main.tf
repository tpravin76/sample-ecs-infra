terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "lls-sample-app-tfstate"
    key    = "state/terraform_state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}