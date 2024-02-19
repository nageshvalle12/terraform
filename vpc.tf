# Create VPC
resource "aws_vpc" "data_runner_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc"
    ENV  = var.app-env
  }
}

# Create 2 Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.data_runner_vpc.id
  cidr_block              = element(["${var.public_subnet_cidr_a}", "${var.public_subnet_cidr_b}"], count.index)
  availability_zone       = element(["${var.aws_region}a", "${var.aws_region}b"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-public-subnet-${count.index}"
    ENV  = var.app-env
  }
}

# Create 2 Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.data_runner_vpc.id
  cidr_block        = element(["${var.private_subnet_cidr_a}", "${var.private_subnet_cidr_b}"], count.index)
  availability_zone = element(["${var.aws_region}a", "${var.aws_region}b"], count.index)
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-private-subnet-${count.index}"
    ENV  = var.app-env
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.data_runner_vpc.id
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-internet-gateway"
    ENV  = var.app-env
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.data_runner_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-public-route-table"
    ENV  = var.app-env
  }
}

# Associate Route Tables with Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Create EIPs for NAT Gateways
resource "aws_eip" "nat_eip" {
  count = 2
}

# Create NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat_gateway" {
  count         = 2
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-nat-gateway-${count.index}"
    ENV  = var.app-env
  }
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_route_table" {
  count  = 2
  vpc_id = aws_vpc.data_runner_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index)
  }
  tags = {
    Name = "${var.app-name}-${var.app-env}-vpc-private-route-table-${count.index}"
    ENV  = var.app-env
  }
}

# Associate Route Tables with Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  count          = 2
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}
