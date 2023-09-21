# variable "env_prefix" {
#   description = "the name of your environment, e.g. \"prod\""
# }

variable "stack_name" {
  description = "the name of your stack, e.g. \"backend\""
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8080
}

variable "public_subnet" {
  description = "Comma separated list of pub subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}

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

variable "acm_certificate_arn" { }
