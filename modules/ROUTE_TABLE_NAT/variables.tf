variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "tags" {
  description = "The tags to associate with the resources"
  type        = map(string)
  default     = {}
}

variable "gateway_id" {
  description = "The ID of the Internet Gateway"
}

variable "allocation_id" {
  description = "The Allocation ID of the EIP associated with the NAT Gateway"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

