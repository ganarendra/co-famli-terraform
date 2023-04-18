resource "aws_s3_bucket" "batch_application_deployment" {
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app"
  force_destroy = true
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.batch_app_s3_bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "batch_app_s3_bucket" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-s3-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "Batch_Ec2 instance"
        Principal = {
          AWS = "${aws_iam_role.batch_ec2_instance_role.arn}"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "Deployment Role"
        Principal = {
          AWS = "${data.aws_iam_role.deployment_sso_role_name.arn}"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "Root Account"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
}

resource "aws_kms_grant" "batch_kms_key_grant" {
  name              = "batch_ec2_instance_grant"
  key_id            = aws_kms_key.batch_app_s3_bucket.key_id
  grantee_principal = aws_iam_role.batch_ec2_instance_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "batch_deployment_kms_key_grant" {
  name              = "batch_deployment_ec2_instance_grant"
  key_id            = aws_kms_key.batch_app_s3_bucket.key_id
  grantee_principal = data.aws_iam_role.deployment_sso_role_name.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.batch_application_deployment.id

  target_bucket = aws_s3_bucket.batch_application_deployment.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.batch_application_deployment.id

  rule {
    id = "rule-1"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "batch_application_deployment_versioning" {
  bucket = aws_s3_bucket.batch_application_deployment.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "batch_application_deployment_block_public_access" {
  bucket = aws_s3_bucket.batch_application_deployment.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "batch_application_deployment_policy_attachment" {
  bucket = aws_s3_bucket.batch_application_deployment.id
  policy = data.aws_iam_policy_document.batch_application_deployment_iam_policy.json
}

data "aws_iam_policy_document" "batch_application_deployment_iam_policy" {
  statement {
    sid    = "S3Access_AWS_Account"
    effect = "Allow"
    resources = [
      aws_s3_bucket.batch_application_deployment.arn,
      "${aws_s3_bucket.batch_application_deployment.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.deployment_sso_role_name.arn]
    }
    actions = ["s3:*"]
  }
  statement {
    sid    = "S3Access_AWS_Account_Ec2"
    effect = "Allow"
    resources = [
      aws_s3_bucket.batch_application_deployment.arn,
      "${aws_s3_bucket.batch_application_deployment.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.batch_ec2_instance_role.arn]
    }
    actions = ["s3:*"]
  }
  statement {
    sid    = "VPCe"
    effect = "Allow"

    resources = [
      aws_s3_bucket.batch_application_deployment.arn,
      "${aws_s3_bucket.batch_application_deployment.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
    actions = [
      "s3:*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
