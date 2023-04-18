data "aws_iam_policy" "fargate_task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_subnet" "app_subnets" {
  for_each = toset(var.subnets)
  id       = each.value
}

data "aws_subnet" "db_subnets" {
  for_each = toset(var.db_subnets)
  id       = each.value
}
data "aws_subnet" "web_subnet" {
  for_each = toset(var.web_subnet)
  id       = each.value
}
data "aws_region" "current" {}

data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "domain" {
  name         = var.application_root_domain
  private_zone = false
}

data "aws_iam_role" "deployment_sso_role" {
  name = var.deployment_sso_role_name
}
