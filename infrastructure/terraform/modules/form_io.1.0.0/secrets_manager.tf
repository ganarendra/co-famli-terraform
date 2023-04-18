resource "aws_secretsmanager_secret" "formio-docdb-secret" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-doc-db-${random_string.random.result}"
  kms_key_id = var.secretsmanager_kms_arn
}

resource "random_string" "random" {
  length  = 6
  special = false
}

resource "aws_secretsmanager_secret_version" "formio_secret_version" {
  secret_id     = aws_secretsmanager_secret.formio-docdb-secret.id
  secret_string = jsonencode({ username = "formio", password = random_password.form_io_docdb_password.result })
}
