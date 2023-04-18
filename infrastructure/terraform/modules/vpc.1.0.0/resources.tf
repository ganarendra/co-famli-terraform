# resource "aws_secretsmanager_secret" "famli-login-gov-public-secret" {
#   name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-login-gov-public-${random_string.random_suffix_cert_secrets.result}"
# }

# resource "aws_secretsmanager_secret" "famli-login-gov-private-secret" {
#   name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-login-gov-private-secret-${random_string.random_suffix_cert_secrets.result}"
# }

# resource "aws_secretsmanager_secret" "famli-pingid-public-secret" {
#   name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pingid-public-secret-${random_string.random_suffix_cert_secrets.result}"
# }

# resource "random_string" "random_suffix_cert_secrets" {
#   length  = 6
#   special = false
# }
