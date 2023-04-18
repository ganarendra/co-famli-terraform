# data "aws_vpc" "id" {
#   id = var.vpc_id
# }
data "aws_caller_identity" "current" {}

# data "archive_file" "rds_microservices_db_backup_lambda" {
#   type        = "zip"
#   source_dir  = "${path.module}/export_rds_snapshot_s3_lambda/"
#   output_path = "${path.module}/export_rds_snapshot_s3_lambda.zip"
# }

data "aws_subnet" "app_subnets" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}
