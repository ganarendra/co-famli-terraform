resource "random_string" "ec2_instance_policy_suffix" {
  length  = 6
  special = false
}

resource "aws_iam_policy" "ec2_instance_policy" {
  #checkov:skip=CKV_AWS_290:Ensure IAM policies does not allow write access without constraints
  #checkov:skip=CKV_AWS_289:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${random_string.ec2_instance_policy_suffix.result}-azure-agent-ecr-policy"
  path        = "/"
  description = "azure_agent_ec2_instance_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect = "Allow"
        Resource = [
          "*"
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
    ]
  })
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${random_string.ec2_instance_policy_suffix.result}-azure-instance-policy"

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

resource "aws_iam_role_policy_attachment" "ec2_instance_policy_attachment_one" {
  # name       = "batch_ec2_instance_policy_attachment_one"
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ec2_instance_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_instance_policy_attachment_two" {
  # name       = "batch_ec2_instance_policy_attachment_two"
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = data.aws_iam_policy.oit_infra_cloudwatch_policy_arn.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "azure_agent_ec2_instance_profile_${var.tags.environment}_${random_string.ec2_instance_policy_suffix.result}"
  role = aws_iam_role.ec2_instance_role.name
}

data "aws_iam_policy" "oit_infra_cloudwatch_policy_arn" {
  name = var.iam_instance_profile_policy
}
