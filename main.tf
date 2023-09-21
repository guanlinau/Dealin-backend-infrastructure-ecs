
provider "aws" {
  region = "ap-southeast-2"
}
locals {
  env = terraform.workspace
}
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "Dealin_Vpc_${local.env}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "internet_gatewas_${local.env}"
  }
}

resource "aws_eip" "nat_gateway" {
  count  = 2
  domain = "vpc"
  tags = {
    Name = "natgateway${count.index + 1}_eip_${local.env}"
  }
}


# resource "aws_eip" "nat_gateway" {
#   domain = "vpc"
#   tags = {
#     Name = "natgateway_eip_${local.env}"
#   }
# }

module "back-route53" {
  source      = "./modules/ROUTE53"
  domain_name = var.domain_name
  aws_region  = var.aws_region
}

module "alb" {
  source        = "./modules/ALB"
  stack_name    = var.stack_name
  vpc_id        = aws_vpc.vpc.id
  public_subnet = module.subnets.public_subnet_ids
  domain_name   = var.domain_name
  # sub_domain_name     = var.sub_domain_name
  sub_domain_name     = var.app_environment == "pro" ? "api.${var.domain_name}" : "${var.app_environment}-api.${var.domain_name}"
  alb_security_groups = [module.security_groups.security_group_alb.id]
  container_port      = var.container_port
  health_check_path   = var.health_check_path
  acm_certificate_arn = module.back-route53.acm_certificate_arn
}

module "subnets" {
  source            = "./modules/SUBNETS"
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
}

module "route_table_nat" {
  source             = "./modules/ROUTE_TABLE_NAT"
  vpc_id             = aws_vpc.vpc.id
  gateway_id         = aws_internet_gateway.internet_gateway.id
  allocation_id      = [aws_eip.nat_gateway[0].id, aws_eip.nat_gateway[1].id]
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}
module "parameters" {
  source                               = "./modules/PARAMETERS_STORE"
  app_name                             = var.stack_name
  task_definition_container_env_values = var.task_definition_container_env_values
}

module "ecr" {
  source   = "./modules/ECR"
  app_name = var.stack_name
}

module "ecs" {
  source                        = "./modules/ECS"
  region                        = var.region
  app_name                      = var.stack_name
  app_port                      = var.container_port
  cpu                           = var.cpu
  memory                        = var.memory
  desired_service_num           = var.desired_service_num
  cpu_target_threshold_value    = var.cpu_target_threshold_value
  memory_target_threshold_value = var.memory_target_threshold_value
  ecs_target_max_capacity       = var.ecs_target_max_capacity
  ecs_target_min_capacity       = var.ecs_target_min_capacity
  cooldown_time                 = var.cooldown_time


  ecs_depends_iam_role_policy  = module.ecs_iam.iam_role_policy
  aws_ecr_repo_url             = module.ecr.aws_ecr_repo.repository_url
  ecs_task_role_arn            = module.ecs_iam.ecs_service_role_arn
  ecs_tasks_execution_role_arn = module.ecs_iam.ecs_task_execution_role_arn
  private_subnet_ids           = module.subnets.private_subnet_ids
  security_groups_ecs          = [module.security_groups.sg_ecs_tasks.id]
  parameters_key_value_pairs   = module.parameters.parameters_key_value_pairs
  target_group_arn             = module.alb.aws_alb_target_group_arn
  alb_listener                 = module.alb.https_listener
  depends_on                   = [module.ecr, module.ecs_iam, module.parameters, module.alb]
}


module "security_groups" {
  source         = "./modules/SECURITY_GROUPS"
  vpc_id         = aws_vpc.vpc.id
  stack_name     = var.stack_name
  container_port = var.container_port
}

module "ecs_iam" {
  source                   = "./modules/IAM_ROLE"
  task_role_name           = var.task_role_name
  task_execution_role_name = var.task_execution_role_name
}

