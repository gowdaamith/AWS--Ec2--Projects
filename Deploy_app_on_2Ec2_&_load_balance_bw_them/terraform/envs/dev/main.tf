provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../modules/vpc"
  cidr   = "10.0.0.0/16"
  public_subnet_cidr ="10.0.1.0/24"
  az = "ap-south-1a"
}
3
moduel "sg" {
 source  = "../../modules/security_group"
 name = "demo-alb"
 vpc_id = module.vpc.vpc_Id
 subnet_id = module.subnet.public_subnet_id
 alb_sg_id = module.sg.alb_sg_id
}
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")   # save your script here 
}
module "asg" {
  source = "../../modules/asg"
  name = "demo"
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = "key_pair_name"
  ec2_sg_name = "demo-ec2-sg"
  tg_arn = module.alb.tg_arn
  subnet_id = module.vpc.public_subnet_id
  min_size = 2
  max_size = 4
  desirec_capacity = 2 
  user_data = data.template_file.user.rendered
}
