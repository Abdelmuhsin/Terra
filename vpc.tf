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
  cidr_block = "10.0.1.0/24"
   map_public_ip_on_launch = "true"

  tags = {
    Name = "web-sub"
  }
}

# api subnet
resource "aws_subnet" "api-sub" {
  vpc_id     = aws_vpc.pr-vpc.id
  cidr_block = "10.0.2.0/24"
   map_public_ip_on_launch = "true"

  tags = {
    Name = "api-sub"
  }
}

# db subnet
resource "aws_subnet" "db-sub" {
  vpc_id     = aws_vpc.pr-vpc.id
  cidr_block = "10.0.3.0/24"
 

  tags = {
    Name = "db-sub"
  }
}

# internet gateway
resource "aws_internet_gateway" "pr-gateway" {
  vpc_id = aws_vpc.pr-vpc.id

  tags = {
    Name = "pr-gateway"
  }
}

# pub route table 
resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.pr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pr-gateway.id
  }

  tags = {
    Name = "pub-route"
  }
}

# pvt route table 
resource "aws_route_table" "pvt-route" {
  vpc_id = aws_vpc.pr-vpc.id

  tags = {
    Name = "pvt-route"
  }
}


# web sub-asoc
resource "aws_route_table_association" "web-asoc" {
  subnet_id      = aws_subnet.web-sub.id
  route_table_id = aws_route_table.pub-route.id
}

# api sub-asoc
resource "aws_route_table_association" "api-asoc" {
  subnet_id      = aws_subnet.api-sub.id
  route_table_id = aws_route_table.pub-route.id
}

# db sub-asoc
resource "aws_route_table_association" "db-asoc" {
  subnet_id      = aws_subnet.db-sub.id
  route_table_id = aws_route_table.pvt-route.id
}

# web nacl
resource "aws_network_acl" "web-nacl" {
  vpc_id = aws_vpc.pr-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "web-nacl"
  }
}

# api nacl
resource "aws_network_acl" "api-nacl" {
  vpc_id = aws_vpc.pr-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "api-nacl"
  }
}

# db nacl
resource "aws_network_acl" "db-nacl" {
  vpc_id = aws_vpc.pr-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "db-nacl"
  }
}

# web nacl asoc
resource "aws_network_acl_association" "web-asoc" {
  network_acl_id = aws_network_acl.web-nacl.id
  subnet_id      = aws_subnet.web-sub.id
}

# api nacl asoc
resource "aws_network_acl_association" "api-asoc" {
  network_acl_id = aws_network_acl.api-nacl.id
  subnet_id      = aws_subnet.api-sub.id
}

# db nacl asoc
resource "aws_network_acl_association" "db-asoc" {
  network_acl_id = aws_network_acl.db-nacl.id
  subnet_id      = aws_subnet.db-sub.id
}