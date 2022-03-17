 resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    tags       = {
      Name = var.vpc_name
    }
  }

  resource "aws_subnet" "main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.cidr_subnet
    tags       = {
      Name = var.subnet_name
    }
  }

  resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
  }

  resource "aws_route_table" "name" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  }

  resource "aws_route_table_association" "main" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table_association.main.id
  }


