data "aws_subnet" "database_subnets" {
  for_each = toset(var.database_subnet_ids)
  id       = each.value
}

data "aws_subnet" "app_subnets" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}


data "aws_iam_policy_document" "assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_kms_key" "sm" {
  key_id = "alias/aws/secretsmanager"
}

data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}

data "aws_region" "this" {
}

data "aws_iam_role" "control_tower_infraadmin_iam_role_arn" {
  name = var.control_tower_sso_infra_iam_role
}

data "aws_iam_policy_document" "rds_secret_policy" {
  statement {
    sid       = "CDLEFAMLIRDSSECRETPOLICY"
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.famli-rds-secret.arn]
    actions   = ["secretsmanager:Get*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.rds_proxy_iam_role.arn,
        data.aws_iam_role.control_tower_infraadmin_iam_role_arn.arn
      ]
    }
  }
}
