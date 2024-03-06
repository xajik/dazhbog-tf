resource "aws_internet_gateway" "shared_igw" {
  vpc_id = aws_vpc.shared_vpc.id
}

resource "aws_vpc" "shared_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.shared_vpc.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_a
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.shared_vpc.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_b
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.shared_vpc.id

  route {
    cidr_block = var.cidr_block_internet
    gateway_id = aws_internet_gateway.shared_igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}