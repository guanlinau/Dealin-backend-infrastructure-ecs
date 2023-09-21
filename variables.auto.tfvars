stack_name = "dealin"

app_environment = "uat"
cidr_block      = ["10.0.0.0/16", "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

availability_zone        = ["ap-southeast-2a", "ap-southeast-2b"]
container_port           = 8080
region                   = "ap-southeast-2"
task_role_name           = "ecs-task-role"
task_execution_role_name = "ecs-task_execution_role"

domain_name       = "offerripple.com"
aws_region        = "ap-southeast-2"
sub_domain_name   = "www.offerripple.com"
health_check_path = "/api/v1/health_check"


#Variable values for ECS
cpu                 = 2048
memory              = 4096
desired_service_num = 2

ecs_target_max_capacity       = 4
ecs_target_min_capacity       = 1
cpu_target_threshold_value    = 80
memory_target_threshold_value = 80

cooldown_time = 60

#Variable values for container environment variables, the values should be given from developer team
task_definition_container_env_values = {
  "API_PREFIX"           = "/api/v1"
  "CONNECTION_STRING"    = ""
  "JWT_KEY"              = ""
  "M3_REGION"            = ""
  "M3_BUCKET_NAME"       = ""
  "M3_ACCESS_KEY_ID"     = ""
  "M3_SECRET_ACCESS_KEY" = ""
  "M3_SAVE_PATH"         = ""
  "PORT"                 = ""
  "NODE_ENV"             = ""
  "GOOGLE_MAP_API"       = ""
}

