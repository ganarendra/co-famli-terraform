resource "aws_kms_key" "kafka_broker_logs" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-kafka-broker-logs-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "dms service"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
      },
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "cloudwatch service"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
      },
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "Root Account"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
}

data "aws_region" "current" {}