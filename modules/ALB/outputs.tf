output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.back_tg.arn
}

output "https_listener"{
    value = aws_alb_listener.https
}

output "aws_lb" {
    value = aws_lb.alb
}