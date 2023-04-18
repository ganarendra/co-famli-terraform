resource "aws_iam_role" "ecs_task_execution_iam_role" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-task-exucution-${random_string.random_suffix_iam_role.result}"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role[*].json)
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attachment" {
  role       = aws_iam_role.ecs_task_execution_iam_role.name
  policy_arn = data.aws_iam_policy.fargate_task_execution_policy.arn
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-task-${random_string.random_suffix_iam_role.result}"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role[*].json)
}

resource "random_string" "random_suffix_iam_role" {
  length  = 6
  special = false
}


resource "aws_iam_role_policy_attachment" "ecs-task-role-attachment" {
  role       = aws_iam_role.ecs_task_iam_role.name
  policy_arn = aws_iam_policy.comunication_service_policy.arn
}

resource "aws_iam_policy" "comunication_service_policy" {
  #checkov:skip=CKV_AWS_290:Ensure IAM policies does not allow write access without constraints
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-task-policy"
  path        = "/"
  description = "SES and SNS Access Polixy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
          "ses:CreateReceiptRule",
          "ses:SetIdentityMailFromDomain",
          "ses:DeleteReceiptFilter",
          "ses:VerifyEmailIdentity",
          "ses:CreateReceiptFilter",
          "ses:CreateConfigurationSetTrackingOptions",
          "ses:ListReceiptFilters",
          "ses:UpdateAccountSendingEnabled",
          "ses:DeleteConfigurationSetEventDestination",
          "ses:GetIdentityMailFromDomainAttributes",
          "ses:DeleteVerifiedEmailAddress",
          "ses:SendEmail",
          "ses:SendTemplatedEmail",
          "ses:SendCustomVerificationEmail",
          "ses:GetIdentityDkimAttributes",
          "ses:UpdateTemplate",
          "ses:DescribeReceiptRuleSet",
          "ses:ListReceiptRuleSets",
          "ses:DeleteConfigurationSetTrackingOptions",
          "ses:GetTemplate",
          "ses:UpdateConfigurationSetTrackingOptions",
          "ses:SetIdentityNotificationTopic",
          "ses:SetIdentityDkimEnabled",
          "ses:CreateConfigurationSet",
          "ses:DeleteReceiptRuleSet",
          "ses:CreateTemplate",
          "ses:ReorderReceiptRuleSet",
          "ses:GetIdentityVerificationAttributes",
          "ses:DescribeReceiptRule",
          "ses:CreateReceiptRuleSet",
          "ses:CreateConfigurationSetEventDestination",
          "ses:SendBulkTemplatedEmail",
          "ses:ListVerifiedEmailAddresses",
          "ses:SetIdentityFeedbackForwardingEnabled",
          "ses:UpdateConfigurationSetEventDestination",
          "ses:ListTemplates",
          "ses:ListCustomVerificationEmailTemplates",
          "ses:DeleteCustomVerificationEmailTemplate",
          "ses:TestRenderTemplate",
          "ses:GetIdentityPolicies",
          "ses:GetSendQuota",
          "ses:DescribeConfigurationSet",
          "ses:DeleteConfigurationSet",
          "ses:DeleteReceiptRule",
          "ses:VerifyDomainDkim",
          "ses:VerifyDomainIdentity",
          "ses:CloneReceiptRuleSet",
          "ses:SetIdentityHeadersInNotificationsEnabled",
          "ses:ListConfigurationSets",
          "ses:ListIdentities",
          "ses:PutConfigurationSetDeliveryOptions",
          "ses:VerifyEmailAddress",
          "ses:UpdateReceiptRule",
          "ses:UpdateConfigurationSetReputationMetricsEnabled",
          "ses:GetCustomVerificationEmailTemplate",
          "ses:SendRawEmail",
          "ses:GetSendStatistics",
          "ses:SendBounce",
          "ses:GetIdentityNotificationAttributes",
          "ses:UpdateConfigurationSetSendingEnabled",
          "ses:ListIdentityPolicies",
          "ses:SetActiveReceiptRuleSet",
          "ses:CreateCustomVerificationEmailTemplate",
          "ses:DescribeActiveReceiptRuleSet",
          "ses:GetAccountSendingEnabled",
          "ses:UpdateCustomVerificationEmailTemplate",
          "ses:DeleteTemplate",
          "ses:SetReceiptRulePosition",
          "ses:DeleteIdentity",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}