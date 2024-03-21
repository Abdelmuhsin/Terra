# vpc 
resource "aws_vpc" "pr-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "pr-vpc"
  }
}

# web subnet
resource "aws_subnet" "web-sub" {
  vpc_id     = aws_vpc.pr-vpc.id
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web-sub"
  }
}

# api subnet
resource "aws_subnet" "api-sub" {
  vpc_id     = aws_vpc.pr-vpc.id
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "api-sub"
  }
}

# db subnet
resource "aws_subnet" "db-sub" {
  vpc_id     = aws_vpc.pr-vpc.id
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "db-sub"
  }
}