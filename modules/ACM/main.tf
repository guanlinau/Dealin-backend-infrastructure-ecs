locals {
  domain_name = var.domain_name
}

provider "aws" {
  region = var.aws_region
  alias  = "ACM_Provider"
}

resource "aws_acm_certificate" "acm_certificate" {
    provider    = aws.ACM_Provider
    domain_name = local.domain_name
    subject_alternative_names = ["*.${local.domain_name}"]
    validation_method = "DNS"
    lifecycle {
      create_before_destroy = true
    }
    tags = {
      Name = "${var.stack_name}-acm-${terraform.workspace}"
      Environment = terraform.workspace
    }   
}