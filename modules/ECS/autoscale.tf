#Configure autoscaling

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_target_max_capacity
  min_capacity       = var.ecs_target_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

   tags = {
    Name        = "${local.tag_name}-ecs-auto-scale"
    Environment = local.environment
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${local.tag_name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_threshold_value
    disable_scale_in =false
    scale_in_cooldown =var.cooldown_time
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${local.tag_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_threshold_value
    disable_scale_in =false
    scale_in_cooldown =var.cooldown_time
  }
}
