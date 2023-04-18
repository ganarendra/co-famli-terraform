resource "aws_cloudwatch_log_group" "ecs_service_logs" {
  count             = length(var.services)
  retention_in_days = 365
  name              = "${var.tags.agency}/${var.tags.project}/${var.tags.environment}/${var.services[count.index]}"
  kms_key_id        = aws_kms_key.batch_kms_key.arn

  tags = var.tags
}

resource "aws_kms_key" "batch_kms_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-service-logs-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "dms service"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "elb service"
        Principal = {
          Service = [
            "logdelivery.elasticloadbalancing.amazonaws.com",
            "logdelivery.elb.amazonaws.com"
          ]
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "cloudwatch service"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "Root Account"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}
