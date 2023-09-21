output "security_group_alb" {
  value = aws_security_group.alb
}

output "sg_ecs_tasks" {
  value = aws_security_group.ecs_tasks
}