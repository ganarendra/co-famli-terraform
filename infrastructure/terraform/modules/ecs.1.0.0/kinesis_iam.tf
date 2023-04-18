# data "aws_iam_policy_document" "firehose_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["firehose.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "firehose_role" {
#   name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-waf-firehouse-waf"
#   assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
# }
