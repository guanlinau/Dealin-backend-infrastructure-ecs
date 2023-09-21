
#KMS key
# output "aws_kms_key_arn" {
#   value =aws_kms_key.ecs-kms-key.arn
# }
# output "aws_kms_key_id" {
#   value =aws_kms_key.ecs-kms-key.key_id
# }

# output "aws_kms_alias_arn" {
#   value = aws_kms_alias.ecs-kms-key-alias.arn
# }

# ECS
output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}
output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}


#ECS Taskdefinition

output "aws_ecs_task_definition_arn" {
  value = aws_ecs_task_definition.aws_ecs_task_df.arn
}

#service
output "aws_ecs_service_id" {
  value = aws_ecs_service.ecs_service.id
}