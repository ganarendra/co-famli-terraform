resource "aws_s3_bucket" "canary_scripts" {
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-canary-scripts"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-canary-scripts" })
}
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_canary_scripts" {
  bucket = aws_s3_bucket.canary_scripts.id

  rule {
    id = "rule-1"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "canary-scripts-block_public_access" {
  bucket = aws_s3_bucket.canary_scripts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "canary_scripts_acl" {
  bucket    = aws_s3_bucket.canary_scripts.id
  acl       = "private"
}
resource "aws_s3_bucket_object" "file_upload" {
  bucket = "aws_s3_bucket.canary_scripts.id"
  key    = "canary_execution.zip"
  source = "canary_execution.zip"
}