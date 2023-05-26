variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "vpc_id" {
  description = "ID of the vpc"
}

variable "emails" {
  default = ["pravin.taralkar@languageline.com"]
}

variable "DYNAMODB_ACCESSKEY" {

}
variable "DYNAMODB_ACCESSSECRET" {

}
variable "SF_USER" {

}
variable "SF_PASS" {

}
variable "SF_CLIENT_ID" {

}
variable "SF_CLIENT_SECRET" {

}
variable "JWT_SECRET" {

}
variable "ES_PRIMARY_USER" {

}
variable "ES_PRIMARY_PASS" {

}
variable "DATADOG_API_KEY" {

}
#variable "certificate_arn" {}
