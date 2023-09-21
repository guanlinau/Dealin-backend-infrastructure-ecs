variable "stack_name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "app_environment" {
  type        = string
  default     = ""
  description = "The environment the app will be deployed"

}

variable "cidr_block" {
  type    = list(any)
  default = []

}

variable "availability_zone" {
  type = list(any)
}

#### ECS /ECR 
variable "cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
  default     = 2048
}

variable "desired_service_num" {
  type    = number
  default = 1

}

variable "ecs_target_max_capacity" {
  type    = number
  default = 3
}

variable "ecs_target_min_capacity" {
  type    = number
  default = 1
}

variable "cpu_target_threshold_value" {
  type    = number
  default = 80

}

variable "memory_target_threshold_value" {
  type    = number
  default = 80

}

variable "cooldown_time" {
  type    = number
  default = 60

}
# Variable for task definition container env
variable "task_definition_container_env_values" {
  description = "Map of parameter names and their values"
  type        = map(string)
  default     = {}
}


############################################### SG
variable "container_port" {
  description = "Ingres and egress port of the container"
  type        = number
  default     = 8080
}

variable "task_execution_role_name" {
  description = "Role name for ECS task execution"
  type        = string
}

variable "task_role_name" {
  description = "Role name for ECS task execution"
  type        = string
}

############################################### ALB
variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/health"
}

variable "domain_name" {
  description = "domain name, e.g. example.com"
}

variable "sub_domain_name" {
  description = "sub domain name, e.g. www.example.com"
}

variable "aws_region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "ap-southeast-2"
}

