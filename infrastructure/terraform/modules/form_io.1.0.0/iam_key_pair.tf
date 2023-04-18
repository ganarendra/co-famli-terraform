resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.formio_user.name
}

resource "aws_iam_user" "formio_user" {
  #checkov:skip=CKV_AWS_273:Ensure access is controlled through SSO and not AWS IAM defined users
  name = "formio_pdf_viewer_user_${var.tags.environment}"
}

resource "aws_iam_user_policy" "lb_ro" {
  #checkov:skip=CKV_AWS_40:Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)
  name = "iam_user_policy_${var.tags.environment}"
  user = aws_iam_user.formio_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:**"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.formio-pdf-bucket.arn}", "${aws_s3_bucket.formio-pdf-bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_secretsmanager_secret" "formio_iam_key_pair" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  kms_key_id = var.secretsmanager_kms_arn
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-formio-iam-${random_string.random.result}"
}

resource "aws_secretsmanager_secret_version" "formio_iam_keypair_secret_version" {
  depends_on = [
    aws_secretsmanager_secret.formio_iam_key_pair,
    aws_iam_access_key.lb
  ]
  secret_id     = aws_secretsmanager_secret.formio_iam_key_pair.id
  secret_string = jsonencode({ username = aws_iam_access_key.lb.id, password = aws_iam_access_key.lb.secret })
}
