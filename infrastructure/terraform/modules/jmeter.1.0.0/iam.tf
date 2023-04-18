resource "aws_iam_role" "jmeter_ec2_instance_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-jmeter-instance-policy"

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

resource "aws_iam_role_policy_attachment" "jmeter_ec2_instance_policy_attachment_two" {
  # name       = "jmeter_ec2_instance_policy_attachment_two"
  role       = aws_iam_role.jmeter_ec2_instance_role.name
  policy_arn = data.aws_iam_policy.oit_infra_cloudwatch_policy_arn.arn
}

resource "aws_iam_instance_profile" "jmeter_ec2_instance_profile" {
  name = "jmeter_ec2_instance_profile_${var.tags.environment}"
  role = aws_iam_role.jmeter_ec2_instance_role.name
}

data "aws_iam_policy" "oit_infra_cloudwatch_policy_arn" {
  name = var.iam_instance_profile_policy
}
