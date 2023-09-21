locals {
  domain_name = var.domain_name
}

provider "aws" {
  region = var.aws_region
  alias  = "ACM_Provider"
}

# data source to fetch hosted zone info from domain name
data "aws_route53_zone" "hosted_zone" {
  name = local.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "acm_certificate" {
  provider    = aws.ACM_Provider
  domain_name = local.domain_name
  # query acm for the sub domain name 
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Environment = terraform.workspace
  }

  lifecycle {
    create_before_destroy = true
  }
}

# use the outputs of aws_acm_certificate to create a Route 53 DNS record to confirm domain ownership
resource "aws_route53_record" "record" {
    for_each = {
        for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

// Wait for the newly created certificate to become valid
resource "aws_acm_certificate_validation" "vail_cert" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}
