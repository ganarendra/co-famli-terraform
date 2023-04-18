data "aws_subnet" "app_subnets" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}


# data "aws_elb_service_account" "main" {}

# data "aws_caller_identity" "current" {}

# data "aws_route53_zone" "domain" {
#   name         = var.application_root_domain
#   private_zone = false
# }

# data "aws_region" "current" {}

# data "aws_iam_policy" "fargate_task_execution_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/formio/"
  output_path = "${path.module}/formio/formio.zip"
}

# data "aws_iam_role" "deployment_sso_role_name" {
#   name = var.deployment_sso_role_name
# }
