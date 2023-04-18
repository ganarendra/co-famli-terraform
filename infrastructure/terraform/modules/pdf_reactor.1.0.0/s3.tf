resource "aws_s3_bucket_object" "pdf_reactor_source_object" {
  depends_on = [
    aws_s3_bucket.pdf_reactor_source_bucket,
    aws_s3_bucket_policy.pdf_reactor_source_bucket_policy
  ]
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id
  key    = "pdf_reactor.rpm"
  source = "${path.module}/pdf_reactor.rpm"
}

resource "aws_s3_bucket_public_access_block" "pdf_reactor_access_block" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id

  target_bucket = aws_s3_bucket.pdf_reactor_source_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "pdf_reactor_source_bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  bucket = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdf-reactor-bundle"
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

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id

  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "pdf_reactor_source_bucket_vesrioning" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "pdf_reactor_source_bucket_block_public_access" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "pdf_reactor_source_bucket_acl" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "pdf_reactor_source_bucket_policy" {
  bucket = aws_s3_bucket.pdf_reactor_source_bucket.id
  policy = data.aws_iam_policy_document.pdf_reactor_source_bucket_policy_document.json
}

data "aws_iam_policy_document" "pdf_reactor_source_bucket_policy_document" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.oit_infra_ec2_instance_role.arn,
        data.aws_iam_role.deployment_sso_role.arn,
        data.aws_iam_role.oit_support_role.arn
      ]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.pdf_reactor_source_bucket.arn}/*",
      aws_s3_bucket.pdf_reactor_source_bucket.arn
    ]
  }
}
