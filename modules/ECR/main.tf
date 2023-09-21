locals {
  environment= terraform.workspace
  tag_name="${var.app_name}-${terraform.workspace}"
}

#Create an aws ecr
resource "aws_ecr_repository" "aws_ecr" {
  name = "${local.tag_name}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${local.tag_name}-ecr"
    Environment = local.environment
  }
}
