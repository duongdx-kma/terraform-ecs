resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge({Name = "${var.env}-main-vpc"}, var.tags)
}

#############################################################################
# Subnets
resource "aws_subnet" "main-public-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}a"

  tags = merge({Name = "${var.env}-main-public-a"}, var.tags)
}

resource "aws_subnet" "main-public-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}b"

  tags = merge({Name = "${var.env}-main-public-b"}, var.tags)
}

resource "aws_subnet" "main-public-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}c"

  tags = merge({Name = "${var.env}-main-public-c"}, var.tags)
}

resource "aws_subnet" "main-private-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = merge({Name = "${var.env}-main-private-a"}, var.tags)
}


resource "aws_subnet" "main-private-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = merge({Name = "${var.env}-main-private-b"}, var.tags)
}

resource "aws_subnet" "main-private-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}c"

  tags = merge({Name = "${var.env}-main-private-c"}, var.tags)
}
#############################################################################
# internet gateway
resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge({Name = "${var.env}-main-gateway"}, var.tags)
}
#############################################################################
# public route table
resource "aws_route_table" "main-public-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = merge({Name = "${var.env}-main-public-route"}, var.tags)
}

#############################################################################
# route associations public subnet
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-a.id
  route_table_id = aws_route_table.main-public-route.id
}

resource "aws_route_table_association" "main-public-1-b" {
  subnet_id      = aws_subnet.main-public-b.id
  route_table_id = aws_route_table.main-public-route.id
}

resource "aws_route_table_association" "main-public-1-c" {
  subnet_id      = aws_subnet.main-public-c.id
  route_table_id = aws_route_table.main-public-route.id
}

# private route table
resource "aws_route_table" "main-private-route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-private-route"
  }
}

#############################################################################
# route associations private subnet
resource "aws_route_table_association" "main-private-1-a" {
  subnet_id      = aws_subnet.main-private-a.id
  route_table_id = aws_route_table.main-private-route.id
}

resource "aws_route_table_association" "main-private-1-b" {
  subnet_id      = aws_subnet.main-private-b.id
  route_table_id = aws_route_table.main-private-route.id
}

resource "aws_route_table_association" "main-private-1-c" {
  subnet_id      = aws_subnet.main-private-c.id
  route_table_id = aws_route_table.main-private-route.id
}



output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
  description = "The cidr_block of the VPC"
}

output "private_subnets" {
  value = [
    aws_subnet.main-private-a.id,
    aws_subnet.main-private-b.id,
    aws_subnet.main-private-c.id
  ]
  description = "List ID of the private subnets"
}

output "public_subnets" {
  value = [
    aws_subnet.main-public-a.id,
    aws_subnet.main-public-b.id,
    aws_subnet.main-public-c.id
  ]
  description = "List ID of the public subnets"
}

output "private-route-table-id" {
  value = aws_route_table.main-private-route.id
}