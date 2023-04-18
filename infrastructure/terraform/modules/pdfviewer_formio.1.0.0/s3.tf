resource "aws_s3_bucket" "formio_pdfviewer" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  bucket = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-pdfviewer-staticsite"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.formio_pdfviewer_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "formio_pdfviewer_kms_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio_pdfviewer-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
}

resource "aws_kms_grant" "formio_pdfviewer_kms_key_grant" {
  name              = "pdfviewer_ec2_instance_grant"
  key_id            = aws_kms_key.formio_pdfviewer_kms_key.key_id
  grantee_principal = aws_iam_role.pdfviewer_ec2_instance_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "formio_pdfviewer_kms_key_grant_deployment" {
  name              = "azure_deployment_grant"
  key_id            = aws_kms_key.formio_pdfviewer_kms_key.key_id
  grantee_principal = data.aws_iam_role.deployment_sso_role_name.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.formio_pdfviewer.id

  target_bucket = aws_s3_bucket.formio_pdfviewer.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.formio_pdfviewer.id

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

resource "aws_s3_bucket_versioning" "formio_pdfviewer_versioning" {
  bucket = aws_s3_bucket.formio_pdfviewer.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "formio_pdfviewer_bucket_block_public_access" {
  bucket = aws_s3_bucket.formio_pdfviewer.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "pdf_viewer_policy_attachment" {
  bucket = aws_s3_bucket.formio_pdfviewer.id
  policy = data.aws_iam_policy_document.pdfviewer_static_site.json
}

data "aws_iam_policy_document" "pdfviewer_static_site" {
  statement {
    sid    = "S3Access_AWS_Account"
    effect = "Allow"
    resources = [
      aws_s3_bucket.formio_pdfviewer.arn,
      "${aws_s3_bucket.formio_pdfviewer.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.deployment_sso_role_name.arn]
    }
    actions = ["s3:*"]
  }
  statement {
    sid    = "S3Access_AWS_Account_Ec2_Instance"
    effect = "Allow"
    resources = [
      aws_s3_bucket.formio_pdfviewer.arn,
      "${aws_s3_bucket.formio_pdfviewer.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.pdfviewer_ec2_instance_role.arn]
    }
    actions = ["s3:*"]
  }
  statement {
    sid    = "S3Access_AWS_Account_Ec2"
    effect = "Allow"
    resources = [
      aws_s3_bucket.formio_pdfviewer.arn,
      "${aws_s3_bucket.formio_pdfviewer.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.iam_instance_profile.arn]
    }
    actions = ["s3:*"]
  }
  statement {
    sid    = "VPCe"
    effect = "Allow"

    resources = [
      aws_s3_bucket.formio_pdfviewer.arn,
      "${aws_s3_bucket.formio_pdfviewer.arn}/*"
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
