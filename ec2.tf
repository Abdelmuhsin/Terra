# EC2 web server
resource "aws_instance" "pr-instance" {
  instance_type = "t2.micro"
  ami                    = "ami-019f9b3318b7155c5"
  key_name               = abd
  subnet_id              = aws_subnet.web-sub.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("setup.sh")
   tags = {
    Name = "pr-instance"
  }
}
  