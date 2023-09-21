locals {
  environment= terraform.workspace
  tag_name="${var.app_name}-${terraform.workspace}"
   container_definition_env_vars_list = [for k, v in var.parameters_key_value_pairs : {name=k, value=v}]
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${local.tag_name}-logs"
  tags = {
    Name        = "${local.tag_name}-logs"
    Environment =  local.environment
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.tag_name}-cluster"

    setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
        kms_key_id = aws_kms_key.ecs-kms-key.arn
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_log_group.name
      }
    }
  }

  tags = {
    Name        = "${local.tag_name}-ecs"
   Environment = local.environment
  }
}

#Create task definition
resource "aws_ecs_task_definition" "aws_ecs_task_df" {
  family = "${local.tag_name}-task"

    container_definitions = jsonencode([
    {
      name = "${local.tag_name}-container"
      image = "${var.aws_ecr_repo_url}"
      environment = local.container_definition_env_vars_list
      
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "${aws_cloudwatch_log_group.ecs_log_group.id}"
          awslogs-region = var.region
          awslogs-stream-prefix ="${local.tag_name}"
        }
      }
      portMappings = [
        {
          containerPort =var.app_port
          hostPort =var.app_port
          protocol = "tcp"
          appProtocol = "http"
        }
      ]
      networkMode = "awsvpc"
      dependsOn: [{
				containerName: "aws-otel-collector"
				condition: "START"
			}]
    },
    {
			name: "aws-otel-collector"
			image: "public.ecr.aws/aws-observability/aws-otel-collector:v0.30.0"
			essential: true
			command: [
				"--config=/etc/ecs/ecs-cloudwatch.yaml"
			]
			logConfiguration: {
				logDriver: "awslogs"
				options: {
					awslogs-create-group: "True"
					awslogs-group: "/ecs/ecs-aws-otel-sidecar-collector"
					awslogs-region: var.region
					awslogs-stream-prefix: "${local.tag_name}"
				}
			}
		}
  ])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = var.ecs_tasks_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  tags = {
    Name        = "${local.tag_name}-ecs-td"
     Environment = local.environment
  }
}

resource "aws_service_discovery_http_namespace" "example" {
  name        = "ecs"
}

# Create ecs service
resource "aws_ecs_service" "ecs_service" {
    name = "${local.tag_name}-service"
    cluster   = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.aws_ecs_task_df.arn
     desired_count   = var.desired_service_num
     launch_type          = "FARGATE"
     scheduling_strategy  = "REPLICA"

     deployment_circuit_breaker {
     enable =true
     rollback = true
  }
     #force_new_deployment = true


    network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups = var.security_groups_ecs
  }

    load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${local.tag_name}-container"
    container_port   = var.app_port
  }
  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.example.arn
    log_configuration {
    log_driver = "awslogs"
      options = {
        awslogs-create-group: "True"
					awslogs-group: "ecs-service-logs"
        awslogs-region = var.region
        awslogs-stream-prefix ="${local.tag_name}"
      }
    }
  }
   tags = {
    Name        = "${local.tag_name}-ecs-service"
     Environment = local.environment
  }

  depends_on = [var.ecs_depends_iam_role_policy, var.alb_listener]
}

