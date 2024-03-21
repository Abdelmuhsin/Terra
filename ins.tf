# instance_type

resource "aws_instance" "pr" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "pr"
  }
}