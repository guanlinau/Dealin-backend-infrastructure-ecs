variable "domain" {
  description = "domain name, e.g. example.com"
}

variable "aws_region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "ap-southeast-2"
}
