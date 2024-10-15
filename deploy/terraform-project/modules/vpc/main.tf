// Create a VPC with the specified CIDR block
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block_vpc

  tags = {
    Name = "VPC-WebApp"
  }
}

// Create a public subnet for web tier within the VPC in two AZ
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_public_subnet_1
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "Public_subnet_Web_1"
  }
}
// Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "VPC-WebApp-Gateway"
  }
}
// Create a public route table for Public Subnets
resource "aws_route_table" "public_subnet_1_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_subnet_1_route_table"
  }
}
// Associate the public route table with the Public subnets
resource "aws_route_table_association" "Public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_1_route_table.id
}



