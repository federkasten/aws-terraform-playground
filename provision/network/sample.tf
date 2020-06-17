resource "aws_vpc" "sample" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "aws-batch-example-vpc"
  }
}

# Security Groups

resource "aws_security_group" "sample" {
  name = "aws_batch_compute_environment_security_group"
  vpc_id = aws_vpc.sample.id
  tags = {
    Name = "aws_batch_compute_environment_security_group-sample-sg"
  }
}

resource "aws_security_group_rule" "sample" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample.id
}

# Subnets

resource "aws_subnet" "sample-main" {
  vpc_id     = aws_vpc.sample.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
}

# Route tables

## Main route table

resource "aws_internet_gateway" "sample" {
  vpc_id = aws_vpc.sample.id
}

resource "aws_route_table" "sample-main" {
  vpc_id = aws_vpc.sample.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample.id
  }
}

resource "aws_route_table_association" "sample-main" {
  subnet_id      = aws_subnet.sample-main.id
  route_table_id = aws_route_table.sample-main.id
}

## Endpoint route table

resource "aws_route_table" "sample-s3" {
  vpc_id = aws_vpc.sample.id
}

resource "aws_vpc_endpoint" "sample-s3" {
  vpc_id       = aws_vpc.sample.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "sample-s3" {
  route_table_id  = aws_route_table.sample-s3.id
  vpc_endpoint_id = aws_vpc_endpoint.sample-s3.id
}

## Associate main route table

resource "aws_main_route_table_association" "sample" {
  vpc_id = aws_vpc.sample.id
  route_table_id = aws_route_table.sample-main.id
}

output "vpc_id" {
  value = aws_vpc.sample.id
}

output "main_subnet_id" {
  value = aws_subnet.sample-main.id
}

output "default_sucurity_group_id" {
  value = aws_security_group.sample.id
}
