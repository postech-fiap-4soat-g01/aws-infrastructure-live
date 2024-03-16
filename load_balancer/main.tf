resource "aws_lb" "FastFoodMonolithLB" {
  name               = "FastFoodMonolithLB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.private_subnets_ids
}

resource "aws_lb_target_group" "FastFoodMonolithTargetGroup" {
  name        = "FastFoodMonolithTargetGroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "api_gateway_listener" {
  load_balancer_arn = aws_lb.FastFoodMonolithLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FastFoodMonolithTargetGroup.arn
  }
}

resource "aws_lb_target_group_attachment" "eks_nodes" {
  target_group_arn = aws_lb_target_group.FastFoodMonolithTargetGroup.arn
  target_id       = var.eks_cluster_arn
}

output "lb_dns_name" {
  value = aws_lb.FastFoodMonolithLB.dns_name
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.api_gateway_listener.arn
}
