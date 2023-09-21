resource "aws_lb" "alb" {
  name               = "ECS-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = [for subnet in var.public_subnet : subnet]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.stack_name}-alb-${terraform.workspace}"
    Environment = terraform.workspace
    }
}

resource "aws_alb_target_group" "back_tg" {
  name        = "ecs-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "120"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.stack_name}-tg-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "https" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 443
    protocol          = "HTTPS"

    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.acm_certificate_arn

    default_action {
        target_group_arn = aws_alb_target_group.back_tg.arn
        type             = "forward"
    }
    tags = {
    Environment = terraform.workspace
    }
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

#Create Alias record towards ALB from Route53
resource "aws_route53_record" "alias_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  # for_each = toset( ["backend.${var.domain_name}", "backend.${var.sub_domain_name}"] )
  # name    = each.key
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
