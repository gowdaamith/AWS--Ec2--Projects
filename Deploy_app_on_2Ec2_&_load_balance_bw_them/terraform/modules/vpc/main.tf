resource "aws_vpc" "this" {
  cidr_block = var.cidr
  enable_dns_support = true
  enable_dns_hostname = true
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = true
}
