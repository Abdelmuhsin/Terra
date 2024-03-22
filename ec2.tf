# EC2 web server
resource "aws_instance" "pr-instance" {
  ami           = "ami-01387af90a62e3c01"
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.api-sub.id
  key_name = "abd.pem"
  security_group_ids = aws_security_group.web-sg.id
  user_data = file("setup.sh")
   tags = {
    Name = "pr-instance"
  }
}
  