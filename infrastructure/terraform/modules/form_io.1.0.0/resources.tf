resource "aws_elastic_beanstalk_application" "form_io" {
  lifecycle {
    ignore_changes = [
      name
    ]
  }
  name        = "formio-${var.tags.environment}"
  description = "formio"
}

resource "aws_elastic_beanstalk_environment" "formio" {
#checkov:skip=CKV_AWS_312:Ensure Elastic Beanstalk environments have enhanced health reporting enabled
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      application,
      name
    ]
  }

  depends_on = [
    aws_docdb_cluster_instance.cluster_instances,
    aws_iam_user.formio_user,
    aws_iam_user_policy.lb_ro,
    aws_secretsmanager_secret_version.formio_iam_keypair_secret_version
  ]

  name        = "form-${var.tags.environment}"
  application = aws_elastic_beanstalk_application.form_io.name

  template_name = aws_elastic_beanstalk_configuration_template.tf_template.name

}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.form_eb_app_versions_bucket.id

  target_bucket = aws_s3_bucket.form_eb_app_versions_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "form_eb_app_versions_bucket" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled // We are not using multiple AWS regions
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-source"
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
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_config" {
  #checkov:skip=CKV_AWS_300:Ensure S3 lifecycle configuration sets period for aborting failed uploads
  bucket = aws_s3_bucket.form_eb_app_versions_bucket.id

  rule {
    id = "rule-1"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    # ... other transition/expiration actions ...

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "form_eb_app_versions_bucket_versioning" {
  bucket = aws_s3_bucket.form_eb_app_versions_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "form_eb_app_versions_bucket_block_public_access" {
  bucket = aws_s3_bucket.form_eb_app_versions_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.formio_eb_role.arn]
#     }

#     actions = [
#       "s3:*"
#     ]

#     resources = [
#       aws_s3_bucket.form_eb_app_versions_bucket.arn,
#       "${aws_s3_bucket.form_eb_app_versions_bucket.arn}/*",
#     ]
#   }
# }

resource "aws_s3_object" "default" {
  bucket = aws_s3_bucket.form_eb_app_versions_bucket.id
  key    = "formio.zip"
  source = data.archive_file.lambda_function_zip.output_path
}

resource "aws_elastic_beanstalk_application_version" "default" {
  lifecycle {
    ignore_changes = [
      name,
      application
    ]
  }
  name        = "formio-${var.tags.environment}"
  application = "formio-${var.tags.environment}"
  description = "formio"
  bucket      = aws_s3_bucket.form_eb_app_versions_bucket.id
  key         = aws_s3_object.default.id
}

resource "aws_security_group" "eb_formio_sg" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-eb-formiosg"
  description = "Allow TLS inbound traffic from app subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-eb-formiosg" })
}
