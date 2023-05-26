variable "region" {
  type        = string
  description = "The AWS Region to use"
  default     = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use"
}

variable "hosted_zone" {
  type        = string
}