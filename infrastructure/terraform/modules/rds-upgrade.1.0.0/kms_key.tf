resource "aws_kms_key" "rds_backup_kms_key" {
  description         = "KMS Key Used for RDS Backups"
  enable_key_rotation = true
}

resource "aws_kms_alias" "rds_backup_kms_key_alias" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-backup-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.rds_backup_kms_key.key_id
}

resource "random_string" "random_suffix" {
  length  = 6
  special = false
}


resource "aws_iam_role" "rds_backup_export_iam_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-backup"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "export.rds.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kms_grant" "a" {
  name              = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-kms-key-grant"
  key_id            = aws_kms_key.rds_backup_kms_key.key_id
  grantee_principal = aws_iam_role.rds_backup_export_iam_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}
