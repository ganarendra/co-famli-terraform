# AWS Documentation link here -> https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html#smtp-credentials-console
# resource "aws_iam_user" "smtp_user" {
#   name = "smtp_user"
# }

# resource "aws_iam_access_key" "smtp_user" {
#   user = aws_iam_user.smtp_user.name
# }

# data "aws_iam_policy_document" "ses_sender" {
#   statement {
#     actions   = ["ses:SendRawEmail"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "ses_sender" {
#   name        = "ses_sender"
#   description = "Allows sending of e-mails via Simple Email Service"
#   policy      = data.aws_iam_policy_document.ses_sender.json
# }

# resource "aws_iam_user_policy_attachment" "test-attach" {
#   user       = aws_iam_user.smtp_user.name
#   policy_arn = aws_iam_policy.ses_sender.arn
# }

# output "smtp_username" {
#   value = aws_iam_access_key.smtp_user.id
# }

# output "smtp_password" {
#   value = aws_iam_access_key.smtp_user.ses_smtp_password_v4
# }

# resource "aws_secretsmanager_secret" "example" {
#   name = "example"
# }

# resource "aws_secretsmanager_secret_version" "example" {
#   secret_id     = aws_secretsmanager_secret.example.id
#   secret_string = "example-string-to-protect"
# }

# resource "random_password" "rds_password" {
#   length  = 16
#   special = false
# }
