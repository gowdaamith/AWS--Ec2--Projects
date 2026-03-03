resource "aws_key_pair" "dev_key"{
  key_name = "dev-key"
  public_key = file("~/.ssh/id_rsa/pub")
}
resource "aws_security_group" "app_sg"{
  name = "app-sg"
  description = "Allow http and ssh"

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = 'tcp'
    cidr_block = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "app_server" {
    ami = "some ami"
    instance_type = "t2.micro"
    key_name = aws_key_pair.dev_key.Key_name
    security_groups = [aws_security_group.app_sg.name]

    user_data = file("${path.modules}/userdata-node.sh")   # terraform will take the file from your local machine and then send its content to AWS as user_data

    tags = {
      name = fuck_you_server
    }
  }
