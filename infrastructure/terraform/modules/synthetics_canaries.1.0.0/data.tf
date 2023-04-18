data "aws_iam_role" "canary_scripts_s3_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-canary_scripts_s3_role"
}
data "aws_s3_bucket" "canary_scripts" {
  bucket        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-canary-scripts"
}