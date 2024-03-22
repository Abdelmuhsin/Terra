# vpc 
resource "aws_vpc" "pr-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "pr-vpc"
  }
}

# web subnet
resource "aws_subnet" "" {
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

# web security group
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = aws_vpc.pr-vpc.id

  tags = {
    Name = "web-sg"
  }
}

#web security group ingress
resource "aws_vpc_security_group_ingress_rule" "web-sg-ssh" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "web-sg-http" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#web security group egress 
resource "aws_vpc_security_group_egress_rule" "web-sg-egress" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# api security group
# security group
resource "aws_security_group" "api-sg" {
  name        = "api-sg"
  description = "Allow SSH & nodejs traffic"
  vpc_id      = aws_vpc.pr-vpc.id

  tags = {
    Name = "api-sg"
  }
}

#api security group ingress
resource "aws_vpc_security_group_ingress_rule" "api-sg-ingress-nodejs" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "api-sg" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

#api security group egress 
resource "aws_vpc_security_group_egress_rule" "api-sg-egress" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# db security group
# security group
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = aws_vpc.pr-vpc.id

  tags = {
    Name = "db-sg"
  }
}

#db security group ingress
resource "aws_vpc_security_group_ingress_rule" "db-sg-ssh" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "db-sg-egress-postgress" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

#db security group egress 
resource "aws_vpc_security_group_egress_rule" "db-sg-egress" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
