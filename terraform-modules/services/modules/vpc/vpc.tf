resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_environment}-internet_gateway"
    Environment = var.app_environment
  }
}
resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_environment}-vpc"
    Environment = var.app_environment
  }
}
output "aws_vpc_id" {
  value = aws_vpc.aws-vpc.id
}
output "aws_internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}