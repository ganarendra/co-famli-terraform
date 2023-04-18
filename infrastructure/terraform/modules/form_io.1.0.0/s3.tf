resource "aws_s3_bucket_policy" "form_pdf_bucket_policy" {
  bucket = aws_s3_bucket.formio-pdf-bucket.id
  policy = data.aws_iam_policy_document.formio_pdf_s3_bucket_policy.json
}

data "aws_iam_policy_document" "formio_pdf_s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.formio_user.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.formio-pdf-bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_logging" "example_2" {
  bucket = aws_s3_bucket.formio-pdf-bucket.id

  target_bucket = aws_s3_bucket.formio-pdf-bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "formio-pdf-bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  force_destroy = true
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-pdf"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_s3_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config_2" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.formio-pdf-bucket.id

  rule {
    id = "rule-1"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "formio-pdf-bucket_versioning" {
  bucket = aws_s3_bucket.formio-pdf-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "formio-pdf-bucket_bucket_block_public_access" {
  bucket = aws_s3_bucket.formio-pdf-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
