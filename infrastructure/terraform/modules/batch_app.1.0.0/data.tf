data "aws_caller_identity" "current" {}

data "aws_iam_role" "deployment_sso_role_name" {
  name = var.deployment_sso_role_name
}

data "aws_region" "current" {}

data "aws_subnet" "app_subnet_ids" {
  for_each = toset(var.app_subnets)
  id       = each.value
}
