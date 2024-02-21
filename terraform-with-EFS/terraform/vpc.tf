data "aws_vpc" "vpc" {
  id = var.vpc_id
}

#resource "aws_internet_gateway" "aws-igw" {
#  vpc_id = data.aws_vpc.vpc.id
#  tags = {
#    Name        = "${var.app_name}-igw"
#    Environment = var.app_environment
#  }
#
#}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}