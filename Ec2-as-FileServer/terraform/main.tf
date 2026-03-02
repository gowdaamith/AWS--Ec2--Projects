resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags= {
    name = "main-vpc"
  }
}
resource "aws_subnet" "public_subnet"{
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  

  tags= {
    name = "main"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "main-igw"
  }
}
resource "aws_route_table" "public_rt" {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
tags= {
  Name = " Public-rt"
}
}
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id 
}
resoruce "aws_security_group" "allow_http_ssh"{
  name = "allow_http_ssh"
  description = "to allown only certain port to acess the server"
  vpc_id =aws_vpc.main.id

  tags = {
    name = " allow_http_ssh"
  }
}  
resource "aws_vpc_security_group_ingress_rule " "allow_ssh"{
  security_group_id = aws_security_group.allow_http_ssh
  form_port = 22
  to_port = 22
  ip_protocol = 'tcp'
  cidr_block = ["0.0.0.0/0"]
}
resource "aws_vpc_security_group_ingress_rule" "allow_http"{
  security_group_id = aws_security_group.allow_http_ssh
  form_port = 80
  to_port = 80
  ip_protocol = 'tcp'
  cidr_block = ["0.0.0.0/0"]
}
resource "aws_vpc_security_group_egress_rule" "allow_all"{
  security_group_id = aws_securitygroup.allow_http_ssh
  cidr_block =["0.0.0.0/0"]
  ip_protocol = "-1"
}
resource "aws_instances" "file_server"{
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro
  seurity_groups = [ aws_security_group.file_sq.
  
  
