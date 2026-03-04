resource "aws_launch_template" " lt" {
  name = "${var.name}-lt
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_group_names = [var.ec2_sg_name]
  user_data = base64encode(var.user_data)
}
resource "aws_autoscaling_group" "asg" {
  name = "${var.name}-asg
  max_size = var.max_size
  min_size =var.min_size
  desired_capacity = var.desired_capacity
  vpc_zone_idnetifiers = [var.subnet_id]
  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }
  target_group_arn= [var.tg_arn]
  health_check_type = "ELB"
  health_chekc_grace_period = 60
  }
  
