provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
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
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr
  availability_zone = var.private_availability_zones

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
  }

  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }

}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
