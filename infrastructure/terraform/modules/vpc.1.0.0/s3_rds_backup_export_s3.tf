# resource "aws_iam_role" "rds_microservices_db_backup_lambda_role" {
#   name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-backup-export-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_lambda_function" "rds_microservices_db_backup_lambda" {
#   depends_on = [
#     aws_iam_role.rds_microservices_db_backup_lambda_role
#   ]
#   filename      = "${path.module}/export_rds_snapshot_s3_lambda.zip"
#   function_name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-snapshot-export"
#   role          = aws_iam_role.rds_microservices_db_backup_lambda_role.arn
#   handler       = "index.lambda_handler"

#   source_code_hash = filebase64sha256("${path.module}/export_rds_snapshot_s3_lambda/index.py")

#   runtime = "python3.8"

#   environment {
#     variables = {
#       s3_bucket = aws_s3_bucket.rds_microservices_db_backup.id
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "rds_microservices_db_backup_lambda_iam_policy_attachment" {
#   depends_on = [
#     aws_iam_role.rds_microservices_db_backup_s3_iam_role,
#     aws_iam_policy.rds_microservices_db_backup_lambda_iam_policy
#   ]
#   # name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-snapshot-policy-attachment"
#   role       = aws_iam_role.rds_microservices_db_backup_lambda_role.name
#   policy_arn = aws_iam_policy.rds_microservices_db_backup_lambda_iam_policy.arn
# }

# resource "aws_iam_policy" "rds_microservices_db_backup_lambda_iam_policy" {
#   name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-backup-export-iam-policy"
#   path        = "/"
#   description = "IAM Policy to Export RDS DB Snapshot to S3"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:**",
#         ]
#         Effect = "Allow"
#         Resource = [
#           aws_s3_bucket.rds_microservices_db_backup.arn,
#           "${aws_s3_bucket.rds_microservices_db_backup.arn}/*",
#         ]
#       },
#       {
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ]
#         Resource = ["arn:aws:logs:*:*:*"]
#         Effect   = "Allow"
#       },
#       {
#         Action = [
#           "sns:*"
#         ]
#         Resource = [aws_sns_topic.rds_microservices_db_backup_lambda_sns_topic.arn]
#         Effect   = "Allow"
#       },
#     ]
#   })
# }

# resource "aws_sns_topic" "rds_microservices_db_backup_lambda_sns_topic" {
#   name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-export-sns-lambda-trigger"
# }

# resource "aws_sns_topic_policy" "default" {
#   arn = aws_sns_topic.rds_microservices_db_backup_lambda_sns_topic.arn

#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }

# data "aws_iam_policy_document" "sns_topic_policy" {
#   policy_id = "__default_policy_ID"

#   statement {
#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceOwner"

#       values = [
#         data.aws_caller_identity.current.id,
#       ]
#     }

#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     resources = [
#       aws_sns_topic.rds_microservices_db_backup_lambda_sns_topic.arn,
#     ]

#     sid = "__default_statement_ID"
#   }

#   statement {
#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]

#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }

#     resources = [
#       aws_sns_topic.rds_microservices_db_backup_lambda_sns_topic.arn,
#     ]

#     sid = "__defaulst_statement_ID"
#   }
# }

# resource "aws_cloudwatch_event_rule" "rdsSnapshotCreation" {
#   name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-snapshot-event-rule"
#   description = "RDS Snapshot Creation"

#   event_pattern = <<PATTERN
# {
#   "source": [
#     "aws.rds"
#   ]
# }
# PATTERN
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.rds_microservices_db_backup_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.rdsSnapshotCreation.arn
# }

# resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
#   rule      = aws_cloudwatch_event_rule.rdsSnapshotCreation.name
#   target_id = "RDSExportLambda"
#   arn       = aws_lambda_function.rds_microservices_db_backup_lambda.arn
# }
