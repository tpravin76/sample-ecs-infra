resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [var.igw]
  tags = {
    Name        = "${var.app_name}-${var.app_environment}-eip"
    Environment = var.app_environment
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.app_name}-nat-gateway"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.app_environment}-private-route-table"
    Environment = var.app_environment
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.app_environment}-public-route-table"
    Environment = var.app_environment
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

output "aws_subnet_public_id" {
  value = aws_subnet.public.*.id
}

output "aws_subnet_private_id" {
  value = aws_subnet.private.*.id
}
