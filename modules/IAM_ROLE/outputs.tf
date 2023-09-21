output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "iam_role_policy" {
  value=aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment
}