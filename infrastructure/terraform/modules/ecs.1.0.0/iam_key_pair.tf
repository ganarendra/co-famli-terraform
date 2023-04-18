resource "aws_iam_access_key" "cloudwatch_user" {
  user = aws_iam_user.cloudwatch_user.name
}

resource "aws_iam_user" "cloudwatch_user" {
  #checkov:skip=CKV_AWS_273:Ensure access is controlled through SSO and not AWS IAM defined users
  name = "cloudwatch_ecs_service_user_${var.tags.environment}"
}

resource "aws_iam_user_policy" "cloudwatch_user_policy" {
  #checkov:skip=CKV_AWS_40:Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)
  name = "iam_user_policy_${var.tags.environment}"
  user = aws_iam_user.cloudwatch_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "cloudwatch:PutDashboard",
                "cloudwatch:PutMetricData",
                "cloudwatch:GetMetricData",
                "cloudwatch:ListMetrics",
                "cloudwatch:StartMetricStreams",
                "cloudwatch:DescribeAnomalyDetectors",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:UntagResource",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:ListDashboards",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:SetAlarmState",
                "cloudwatch:PutAnomalyDetector",
                "cloudwatch:GetMetricWidgetImage",
                "cloudwatch:PutManagedInsightRules",
                "cloudwatch:DescribeInsightRules",
                "cloudwatch:GetDashboard",
                "cloudwatch:GetInsightRuleReport",
                "cloudwatch:EnableInsightRules",
                "cloudwatch:Link",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:PutCompositeAlarm",
                "cloudwatch:ListManagedInsightRules",
                "cloudwatch:PutMetricStream",
                "cloudwatch:PutInsightRule",
                "cloudwatch:TagResource",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:EnableAlarmActions",
                "cloudwatch:ListMetricStreams",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:GetMetricStream"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_secretsmanager_secret" "cloudwatch_user_key_pair" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  kms_key_id = var.secretsmanager_kms_arn
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-cloudwatch-ecs-iam-kp-${random_string.random_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "formio_iam_keypair_secret_version" {
  depends_on = [
    aws_secretsmanager_secret.cloudwatch_user_key_pair,
    aws_iam_access_key.cloudwatch_user
  ]
  secret_id     = aws_secretsmanager_secret.cloudwatch_user_key_pair.id
  secret_string = jsonencode({ username = aws_iam_access_key.cloudwatch_user.id, password = aws_iam_access_key.cloudwatch_user.secret })
}
