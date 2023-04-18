resource "aws_transfer_server" "sftp_gateway" {
  endpoint_type = "VPC"

  protocols              = ["SFTP"]
  identity_provider_type = "SERVICE_MANAGED"

  endpoint_details {
    address_allocation_ids = [aws_eip.sftp_1.id, aws_eip.sftp_2.id, aws_eip.sftp_3.id]
    subnet_ids             = var.web_subnet_ids
    vpc_id                 = var.vpc_id
    security_group_ids     = [aws_security_group.aws_transfer_family_security_group.id]
  }

  logging_role = aws_iam_role.sftp_gateway_monitoring_role.arn

  tags = merge(var.tags, { "transfer:route53HostedZoneId" = "/hostedzone/${data.aws_route53_zone.domain.zone_id}", "transfer:customHostname" = "sftp.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}" })
}

resource "aws_eip" "sftp_1" {
  vpc = true
}

resource "aws_eip" "sftp_2" {
  vpc = true
}

resource "aws_eip" "sftp_3" {
  vpc = true
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.sftp_gateway_bucket.id

  target_bucket = aws_s3_bucket.sftp_gateway_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.sftp_gateway_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "sftp_gateway_bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  bucket = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-gateway"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.sftp_gateway_s3_bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.sftp_gateway_bucket.id

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

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.sftp_gateway_bucket.id
  acl    = "private"
}

resource "aws_iam_role" "sftp_gateway_monitoring_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-transfer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "sftp_gateway_monitoring_iam_policy" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-iam-policy"
  path        = "/"
  description = "batch_ec2_instance_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/transfer/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sftp_monitoring_role_policy_attachment" {
  role       = aws_iam_role.sftp_gateway_monitoring_role.name
  policy_arn = aws_iam_policy.sftp_gateway_monitoring_iam_policy.arn
}


resource "aws_kms_key" "sftp_gateway_s3_bucket" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-bucket-kms-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "tftestuser"
        Principal = {
          AWS = "${aws_iam_role.foo.arn}"
        }
      },
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "DPAUser"
        Principal = {
          AWS = "${aws_iam_role.dpa_user.arn}"
        }
      },
      {
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
        Sid    = "Root Account"
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
