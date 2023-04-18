resource "aws_sns_topic" "famli" {
  name              = "cdle-famli-${var.tags.environment}-sns"
  kms_master_key_id = var.kms_sns_arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.famli.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_sms_preferences" "update_sms_prefs" {
  monthly_spend_limit = "100"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.famli.arn,
    ]

    sid = "__default_statement_ID"
  }
}
