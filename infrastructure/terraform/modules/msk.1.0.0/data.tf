data "aws_subnet" "app_subnets" {
  for_each = toset(var.subnets)
  id       = each.value
}


# data "aws_kms_key" "sm_kafka" {
#   key_id = "alias/aws/secretsmanager"
# }

data "aws_caller_identity" "current" {}