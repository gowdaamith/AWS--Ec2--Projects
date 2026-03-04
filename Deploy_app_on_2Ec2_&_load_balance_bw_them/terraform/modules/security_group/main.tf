resource "aws_security_group" "ec2_sg"{
  name = "${var.name}-ec2-sg"
  description = "Ec2 SG for node.js app"
  vpc_id = var.vpc_id 

  ingress {
    from_portt = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg"{
  name = ${var.name}-alb-sg
  description = "ALB SG"
  vpc_id = var.vpc_id

  ingress {
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

  


    
