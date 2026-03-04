resource "aws_lb" "lb" {
  name = var.name
  internal = true
  load_balancer_type = "application"
  security_group = [var.alb_sg.id]
  subnets = [var.subnet.id]
}
resource "aws_lb_target_group" "tg" {
  name = "${var.name}-tg
  port = 3000
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhelthy_thershold = 2
  }
}
resource "aws_lb_listener" "http" {  
    loab_balancer_arn = aws_lb.lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}
  

  
