resource "aws_kms_key" "ecs-kms-key" {
  description             = "${local.tag_name}-ecs_kms_key"
  deletion_window_in_days = 7
  is_enabled=true
#   enable_key_rotation=true
  tags = {
    Name        = "${local.tag_name}-kms_key"
    Environment =  local.environment
  }
}

resource "aws_kms_alias" "ecs-kms-key-alias" {
  name          = "alias/${local.tag_name}-key"
  target_key_id = aws_kms_key.ecs-kms-key.key_id
}