### Variable value sample

```
stack_name               = "demo"

cidr_block               = ["10.0.0.0/16", "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
VPC_cidr_block = cidr_block[0]
pub_subnet_1_cidr_block = cidr_block[1]
pub_subnet_2_cidr_block = cidr_block[2]
pri_subnet_1_cidr_block = cidr_block[3]
pri_subnet_2_cidr_block = cidr_block [4]

availability_zone        = ["ap-southeast-2a", "ap-southeast-2b"]
container_port           = 8080
region                   = "ap-southeast-2"
task_role_name           = "ecs-task-role"
task_execution_role_name = "ecs-task_execution_role"

domain_name       = "offerripple.com"
aws_region        = "ap-southeast-2"
sub_domain_name   = "www.offerripple.com"
health_check_path = "/V1/health"


#Variable values for ECS
cpu                 = 1024
memory              = 2048
desired_service_num = 2

ecs_target_max_capacity =3
ecs_target_min_capacity =1
cpu_target_threshold_value = 80
memory_target_threshold_value = 80
cooldown_time                     = 60

#Variable values for Parameters store, the value should be given from developer team
task_definition_container_env_values = {
  "CONNECTION_STRING"    = ""
  "JWT_KEY"=""
  "M3_REGION"            = ""
  "M3_BUCKET_NAME"       = ""
  "M3_ACCESS_KEY_ID"     = ""
  "M3_SECRET_ACCESS_KEY" = ""
  "M3_SAVE_PATH"         = ""
  "PORT"                 = ""
  "NODE_ENV"             =""
}

```
