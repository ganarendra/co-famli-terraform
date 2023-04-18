resource "aws_lb" "batch_app_elb" {
  enable_deletion_protection = true
  name                       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app-lb"
  security_groups            = [aws_security_group.batch_app_lb_security_group.id]

  internal                   = true
  subnets                    = var.app_subnets
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.lb_log_bucket.bucket
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app-lb" })
}

resource "aws_s3_bucket" "lb_log_bucket" {
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-web-lb-logs"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # kms_master_key_id = aws_kms_key.batch_kms_key.arn
        sse_algorithm     = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-lb-logs" })
}

resource "aws_kms_key" "batch_kms_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-web-logs-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "dms service"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "elb service"
        Principal = {
          Service = [
            "logdelivery.elasticloadbalancing.amazonaws.com",
            "logdelivery.elb.amazonaws.com"
          ]
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "cloudwatch service"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
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

resource "aws_lb_listener" "batch_app_front_end_redirect" {
  load_balancer_arn = aws_lb.batch_app_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_alb_listener" "batch_app_secure_listener" {

  load_balancer_arn = aws_lb.batch_app_elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = aws_acm_certificate.batch_app_acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.batch_app_lb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "batch_app_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.batch_app_lb_target_group.arn
  target_id        = aws_instance.ec2.id
  port             = 443
}


resource "aws_lb_target_group" "batch_app_lb_target_group" {
  name_prefix = "batch"

  lifecycle {
    create_before_destroy = true
  }

  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    path     = "/ping"
    protocol = "HTTPS"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config_batch" {
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

resource "aws_s3_bucket_public_access_block" "lb_log_bucket_block_public_access_batch" {
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

resource "aws_s3_bucket_versioning" "lb_log_bucket_versioning_batch" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "lb_log_bucket_policy_batch" {
  bucket = aws_s3_bucket.lb_log_bucket.id
  policy = data.aws_iam_policy_document.aws_lb_logs_s3_bucket_policy.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "aws_lb_logs_s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb_log_bucket.arn}/*",
      "${aws_s3_bucket.lb_log_bucket.arn}"
    ]
  }
}