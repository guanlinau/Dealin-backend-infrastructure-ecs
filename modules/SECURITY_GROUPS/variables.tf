variable "stack_name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
}
