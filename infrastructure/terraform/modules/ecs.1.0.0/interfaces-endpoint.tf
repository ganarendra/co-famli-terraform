############################################################
# Intefaces endpoint -> path based routing
############################################################
resource "aws_route53_record" "interfaces_endpoint" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "interfaces.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.interfaces_endpoint.dns_name]
}

resource "aws_wafv2_web_acl_association" "interfaces_lb_waf_association" {
  resource_arn = aws_lb.interfaces_endpoint.arn
  web_acl_arn  = aws_wafv2_web_acl.ecs_service_lb_waf_sec.arn
}

resource "aws_lb" "interfaces_endpoint" {
  enable_deletion_protection = true
  #checkov:skip=CKV2_AWS_20:Ensure that ALB redirects HTTP requests into HTTPS ones
  depends_on = [
    aws_s3_bucket.interfaces_lb_log_bucket,
    aws_s3_bucket_policy.interfaces_lb_log_bucket_policy_batch
  ]

  idle_timeout               = 60
  drop_invalid_header_fields = true

  security_groups = var.expose_web == true ? [aws_security_group.lb_security_group_expose_web.id, aws_security_group.lb_security_group_uat_testers.id] : [aws_security_group.lb_security_group.id]

  internal = true
  name     = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-interfaces"

  subnets = var.web_subnet

  access_logs {
    bucket  = aws_s3_bucket.interfaces_lb_log_bucket.bucket
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-interfaces-endpoint" })
}

resource "aws_s3_bucket" "interfaces_lb_log_bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-interfaces-endpoint-lb-logs"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # kms_master_key_id = aws_kms_key.batch_kms_key.arn
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-interfaces-endpoint-lb-logs" })
}

resource "aws_s3_bucket_lifecycle_configuration" "interfaces_s3_bucket_lifecycle_config_batch" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.interfaces_lb_log_bucket.id

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

resource "aws_s3_bucket_public_access_block" "interfaces_lb_log_bucket_block_public_access_batch" {
  bucket = aws_s3_bucket.interfaces_lb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "interfaces_lb_log_bucket_acl" {
  bucket = aws_s3_bucket.interfaces_lb_log_bucket.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "interfaces_lb_log_bucket_versioning_batch" {
  bucket = aws_s3_bucket.interfaces_lb_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "interfaces_lb_log_bucket_policy_batch" {
  bucket = aws_s3_bucket.interfaces_lb_log_bucket.id
  policy = data.aws_iam_policy_document.interfaces_aws_lb_logs_s3_bucket_policy.json
}

data "aws_iam_policy_document" "interfaces_aws_lb_logs_s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.interfaces_lb_log_bucket.arn}/*",
      "${aws_s3_bucket.interfaces_lb_log_bucket.arn}"
    ]
  }
}