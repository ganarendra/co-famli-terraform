resource "aws_iam_role" "canary_scripts_s3_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-canary_scripts_s3_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = ["*"]
      },
    ]
  })
}