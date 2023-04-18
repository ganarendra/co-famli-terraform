resource "aws_s3_bucket_logging" "logging_2" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  target_bucket = aws_s3_bucket.lb_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "lb_log_bucket" {
  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration
    ]
  }
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-services-lb-logs"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_s3_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-lb-logs" })
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.lb_log_bucket.id

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

resource "aws_s3_bucket_public_access_block" "lb_log_bucket_block_public_access" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "lb_log_bucket_acl" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "lb_log_bucket_public_access_block" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "lb_log_bucket_versioning" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "lb_log_bucket_policy" {
  bucket = aws_s3_bucket.lb_log_bucket.id
  policy = data.aws_iam_policy_document.aws_lb_logs_s3_bucket_policy.json
}

data "aws_iam_policy_document" "aws_lb_logs_s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn, "127311923021"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      for service in var.services : "${aws_s3_bucket.lb_log_bucket.arn}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.cert_bucket.id

  target_bucket = aws_s3_bucket.cert_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "cert_bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-cert-bucket"
  force_destroy = true
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

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-lb-logs" })
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config_2" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.cert_bucket.id

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

resource "aws_s3_bucket_public_access_block" "cert_bucket_block_public_access" {
  bucket = aws_s3_bucket.cert_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cert_bucket_policy" {
  bucket = aws_s3_bucket.cert_bucket.id
  policy = data.aws_iam_policy_document.cert_s3_bucket_policy.json
}

data "aws_iam_policy_document" "cert_s3_bucket_policy" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.ecs_task_execution_iam_role.arn,
        data.aws_elb_service_account.main.arn,
        data.aws_iam_role.deployment_sso_role.arn

      ]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.cert_bucket.arn}/*"
    ]
  }
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
}