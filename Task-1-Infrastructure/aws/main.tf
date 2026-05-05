provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
}

# Subnets
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.3.0/24"
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public1.id
  depends_on = [aws_internet_gateway.igw]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "priv1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

# Security Group
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key Pair
resource "aws_key_pair" "key" {
  key_name = "capstone-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# EC2
resource "aws_instance" "app" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name = aws_key_pair.key.key_name
}

resource "aws_instance" "tools" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name = aws_key_pair.key.key_name
}
