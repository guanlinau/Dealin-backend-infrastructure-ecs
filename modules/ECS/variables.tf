variable "app_name" {
  type    = string
  default = null
}
variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "aws_ecr_repo_url" {
  type = string
}

variable "app_port" {
  type    = number
  default = 8080
}

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

variable "ecs_tasks_execution_role_arn" {
  
}
variable "ecs_task_role_arn" {
  
}

variable "desired_service_num" {
    type = number
    default = 1
  
}

variable "private_subnet_ids" {
  type=list(string)
}

variable "security_groups_ecs" {
  type=list(string)
}

variable "target_group_arn" {
  type=string
}

variable "ecs_depends_iam_role_policy" {
  
}
variable "alb_listener" {
    
}

variable "parameters_key_value_pairs" {
  type = map(string)
  default = {}
}


variable "ecs_target_max_capacity" {
  type = number
  default = 3  
}

variable "ecs_target_min_capacity" {
  type = number
  default = 1
}

variable "cpu_target_threshold_value" {
  type=number
  default = 80
  
}

variable "memory_target_threshold_value" {
  type=number
  default = 80
  
}

variable "cooldown_time" {
  type = number
  default = 60
  
}
