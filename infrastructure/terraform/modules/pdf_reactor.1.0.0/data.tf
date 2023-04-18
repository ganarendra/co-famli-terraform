data "aws_iam_role" "deployment_sso_role" {
  name = var.deployment_sso_role_name
}

data "aws_iam_role" "oit_infra_ec2_instance_role" {
  name = var.oit_infra_ec2_instance_role_name
}

# data "aws_elb_service_account" "main" {}

data "aws_iam_role" "oit_support_role" {
  name = var.oit_support_role
}

data "aws_subnet" "app_subnet_ids" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}
