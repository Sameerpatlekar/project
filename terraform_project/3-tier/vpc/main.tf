resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_availability_zones

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr
  availability_zone = var.private_availability_zones

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      =  aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }

}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name        = "${var.environment}-aws-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name        = "${var.environment}-nat-gateway"
    Environment = var.environment
  }
}
