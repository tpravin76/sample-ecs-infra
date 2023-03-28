data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_eip" "eip" {
  id = var.eip_id
}

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id

  tags = {
    Name = "*${var.app_name}-private-subnet*"
  }
}

data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.app_name}*"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = data.aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.app_name}-nat-gateway"
    Environment = var.app_environment
  }
}

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

resource "aws_route_table_association" "route_table_association" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.public.id
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