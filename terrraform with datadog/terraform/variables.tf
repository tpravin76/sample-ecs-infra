variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 1
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
  description = "ARN of the vpc"
}
variable "eip_id" {
  description = "elastic ip id"
}

variable "SF_USER" {

}
variable "SF_PASS" {

}
variable "SF_SANDBOX" {

}
variable "SF_CLIENT_ID" {

}
variable "SF_CLIENT_SECRET" {

}
variable "ES_PASS" {

}
variable "REPLICATE_PASS" {

}
variable "DATADOG_API_KEY" {

}
