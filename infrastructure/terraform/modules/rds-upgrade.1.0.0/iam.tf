resource "aws_iam_role" "rds_monitoring_instance_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-monitory-policy-${random_string.rds_iam_role_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.rds_monitoring_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "random_string" "rds_iam_role_suffix" {
  length  = 6
  special = false
}
