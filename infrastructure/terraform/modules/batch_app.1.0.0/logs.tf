# resource "aws_cloudwatch_log_group" "producer_listener_batch" {
#   name              = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-producer-listener-logs"
#   retention_in_days = 365
#   # kms_key_id = var.kms_cloudwatch_arn
# }

# resource "aws_cloudwatch_log_group" "batch_web_logs" {
#   name              = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-web-logs-bucket"
#   retention_in_days = 365
#   # kms_key_id = var.kms_cloudwatch_arn
# }
