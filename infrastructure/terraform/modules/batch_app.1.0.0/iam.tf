resource "aws_iam_policy" "batch_ec2_instance_policy" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-ecr-policy"
  path        = "/"
  description = "batch_ec2_instance_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect = "Allow"
        Resource = [
          aws_ecr_repository.batch_web_repo.arn,
          "${aws_ecr_repository.batch_web_repo.arn}/*"
        ]
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.batch_application_deployment.arn}",
          "${aws_s3_bucket.batch_application_deployment.arn}/*"
        ]
      },
      {
        Action = [
          "kms:*",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_kms_key.batch_app_s3_bucket.arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "batch_ec2_instance_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-instance-policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "batch_ec2_instance_policy_attachment_one" {
  # name       = "batch_ec2_instance_policy_attachment_one"
  role       = aws_iam_role.batch_ec2_instance_role.name
  policy_arn = aws_iam_policy.batch_ec2_instance_policy.arn
}

resource "aws_iam_role_policy_attachment" "batch_ec2_instance_policy_attachment_two" {
  # name       = "batch_ec2_instance_policy_attachment_two"
  role       = aws_iam_role.batch_ec2_instance_role.name
  policy_arn = data.aws_iam_policy.oit_infra_cloudwatch_policy_arn.arn
}

resource "aws_iam_instance_profile" "batch_ec2_instance_profile" {
  name = "batch_ec2_instance_profile_${var.tags.environment}"
  role = aws_iam_role.batch_ec2_instance_role.name
}

data "aws_iam_policy" "oit_infra_cloudwatch_policy_arn" {
  name = var.iam_instance_profile_policy
}
