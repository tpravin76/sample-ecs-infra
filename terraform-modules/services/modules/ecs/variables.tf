variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "aws_ecr_repository_url" {
  description = "aws ecr repository url"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "vpc_id" {
  description = "ID of the vpc"
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
variable "ecsTaskExecutionRoleArn" {

}
#variable "certificate_arn" {}
