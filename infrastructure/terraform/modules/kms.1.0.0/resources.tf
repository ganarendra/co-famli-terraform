resource "random_string" "random_suffix" {
  length  = 4
  special = false
}

resource "aws_kms_key" "ecr_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecr-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "ecr_alias" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/ECR-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.ecr_key.key_id
}

resource "aws_kms_key" "s3_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-s3-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "s3_alias" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/S3-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_key" "cloudwatch_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-cloudwatch-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "cloudwatch_alias" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/cloudwatch-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_key" "secretsmanager_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-secretsmanager-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "secretsmanager_key" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/secretsmanager-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_key" "docdb_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-docdb-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "docdb_key" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/docdb-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.docdb_key.key_id
}

resource "aws_kms_key" "ebs_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ebs-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "ebs_key" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/EBS-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.ebs_key.key_id
}

resource "aws_kms_key" "sns_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sns-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "sns_key" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/SNS-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.ebs_key.key_id
}

resource "aws_kms_key" "msk_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-msk-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "msk_key" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/MSK-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.msk_key.key_id
}

resource "aws_kms_key" "firehose" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-firehose-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "aws_kms_alias" "firehose" {
  name          = "alias/${var.tags.agency}-${var.tags.project}-${var.tags.environment}/Firehose-${random_string.random_suffix.result}"
  target_key_id = aws_kms_key.firehose.key_id
}
