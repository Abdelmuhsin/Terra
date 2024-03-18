# VPC
resource "aws_vpc" "pr" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "pr"
  }
} 


 # Web subnet
resource "aws_subnet" "web-sub" {
  vpc_id     = aws_vpc.pr.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true" 
  tags = {
    Name = "web-sub"
  }
}


 # api subnet
resource "aws_subnet" "api-sub" {
  vpc_id     = aws_vpc.pr.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true" 
  tags = {
    Name = "api-sub"
  }
}


 # db subnet
resource "aws_subnet" "db-sub" {
  vpc_id     = aws_vpc.pr.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "db-sub"
  }
}

# internet gateway
resource "aws_internet_gateway" "pr-gw" {
  vpc_id = aws_vpc.pr.id
  tags = {
    Name = "pr-gw"
  }
}

 # pub route table
 resource "aws_route_table" "pub-pr-rt" {
  vpc_id = aws_vpc.pr.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pr-gw.id
  }

  tags = {
    Name = "pub-pr-route"
  }
}

