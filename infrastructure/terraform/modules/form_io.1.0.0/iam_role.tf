resource "aws_iam_role" "formio_eb_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-setup"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "elasticbeanstalk.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "formio_instance_profile" {
  name = "formio_instance_profile_${var.tags.environment}"
  role = aws_iam_role.formio_eb_role.name
}

resource "aws_iam_policy" "formio_eb_policy" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-eb-policy"

  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  #checkov:skip=CKV_AWS_108:Ensure IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_109:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  #checkov:skip=CKV_AWS_107:Ensure IAM policies does not allow credentials exposure
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticbeanstalk:List*",
      "elasticbeanstalk:Describe*",
      "elasticbeanstalk:Request*",
      "elasticbeanstalk:Retrieve*",
      "ec2:Describe*",
      "ec2:Get*",
      "cloudformation:Describe*",
      "cloudformation:List*",
      "cloudformation:Get*",
      "autoscaling:Describe*",
      "elasticloadbalancing:Describe*",
      "s3:Head*",
      "s3:List*",
      "s3:Get*",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:GetConsoleOutput",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeNotificationConfigurations",
      "sns:Publish",
    ]
  }

  statement {
    sid    = "BucketAccess"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::elasticbeanstalk-*",
      "arn:aws:s3:::elasticbeanstalk-*/*",
    ]

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject",
    ]
  }

  statement {
    sid       = "XRayAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries",
    ]
  }

  statement {
    sid       = "CloudWatchLogsAccess"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"]

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::elasticbeanstalk-*"]
    actions   = ["s3:*"]
  }

  statement {
    sid    = "ElasticBeanstalkHealthAccess"
    effect = "Allow"

    resources = [
      "arn:aws:elasticbeanstalk:*:*:application/*",
      "arn:aws:elasticbeanstalk:*:*:environment/*",
    ]

    actions = ["elasticbeanstalk:PutInstanceStatistics"]
  }

  statement {
    sid    = "ECRAccess"
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = ["ecr:*"]
  }

  statement {
    sid    = "S3Access"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.formio-pdf-bucket.arn}*",
      "${aws_s3_bucket.formio-pdf-bucket.arn}/*"
    ]

    actions = ["s3:*"]
  }
}

resource "aws_iam_role_policy_attachment" "s3_policy_for_lambda_iam_role_attachment" {
  # name       = "s3_policy_for_lambda_attachment"
  policy_arn = aws_iam_policy.formio_eb_policy.arn
  role       = aws_iam_role.formio_eb_role.name
}
