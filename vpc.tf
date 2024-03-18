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

# pvt route table
resource "aws_route_table" "pvt-pr-rt" {
  vpc_id = aws_vpc.pr.id

  tags = {
    Name = "pvt-pr-rt"
  }
}

# rt pub asoc
resource "aws_route_table_association" "pr-pub-asoc" {
  subnet_id      = aws_subnet.web-sub.id
  route_table_id = aws_route_table.pub-pr-rt.id
}

# rt api as
 resource "aws_route_table_association" "pr-api-asoc" {
  subnet_id      = aws_subnet.api-sub.id
  route_table_id = aws_route_table.pub-pr-rt.id
}

# rt db asoc
 resource "aws_route_table_association" "pr-db-asoc" {
  subnet_id      = aws_subnet.db-sub.id
  route_table_id = aws_route_table.pvt-pr-rt.id
}

# nacl web
resource "aws_network_acl" "pr-web-nacl" {
  vpc_id = aws_vpc.pr.id

  # Rules for inbound traffic (ingress)
  ingress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }

  # Rules for outbound traffic (egress)
  egress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }



 tags = {
    Name = "pr-nacl"
  }

}

 # nacl web
resource "aws_network_acl" "pr-web-nacl" 
  vpc_id = aws_vpc.pr.id

  # Rules for inbound traffic (ingress)
  ingress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }

  # Rules for outbound traffic (egress)
  egress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }

 tags = {
    Name = "api-nacl"
  }

  # nacl db
resource "aws_network_acl" "pr-db-nacl" 
  vpc_id = aws_vpc.pr.id

  # Rules for inbound traffic (ingress)
  ingress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }

  # Rules for outbound traffic (egress)
  egress {
    rule_no  = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  }

 tags = {
    Name = "db-nacl"
  }  
