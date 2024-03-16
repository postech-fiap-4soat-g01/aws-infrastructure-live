resource "aws_lb" "FastFoodMonolithLB" {
  name               = "FastFoodMonolithLB"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [var.security_group_id]
  subnets            = var.private_subnets_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "FastFoodMonolithTargetGroup" {
  name        = "FastFoodMonolithTargetGroup"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "api_gateway_listener" {
  load_balancer_arn = aws_lb.FastFoodMonolithLB.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FastFoodMonolithTargetGroup.arn
  }
}

output "lb_dns_name" {
  value = aws_lb.FastFoodMonolithLB.dns_name
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.api_gateway_listener.arn
}
