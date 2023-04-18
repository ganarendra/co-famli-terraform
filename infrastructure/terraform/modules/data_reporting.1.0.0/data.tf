data "aws_subnet" "database_subnets" {
  for_each = toset(var.database_subnet_ids)
  id       = each.value
}

data "aws_caller_identity" "current" {}

# data "aws_iam_policy_document" "assume_role" {

#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["rds.amazonaws.com"]
#     }
#   }
# }

# data "aws_kms_key" "sm" {
#   key_id = "alias/aws/secretsmanager"
# }

data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}

# data "aws_region" "this" {
# }

data "aws_secretsmanager_secret" "source_db_secret_arn" {
  arn = var.source_db_secret_arn
}

data "aws_secretsmanager_secret_version" "source_db_secret" {
  secret_id = data.aws_secretsmanager_secret.source_db_secret_arn.id
}
