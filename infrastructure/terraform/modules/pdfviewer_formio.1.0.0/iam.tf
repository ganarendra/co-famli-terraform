resource "aws_iam_policy" "pdfviewer_ec2_instance_policy" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdfviewer-policy"
  path        = "/"
  description = "pdfviewer_ec2_instance_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.formio_pdfviewer.arn}",
          "${aws_s3_bucket.formio_pdfviewer.arn}/*"
        ]
      },
      {
        Action = [
          "kms:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:kms:us-east-1:990189637847:key/1bae23e3-db5e-4b7b-b122-fcfb4bbdd7e5"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "pdfviewer_ec2_instance_role" {
  name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdfviewer-instance-policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pdfviewer_ec2_instance_policy_attachment_one" {
  role       = aws_iam_role.pdfviewer_ec2_instance_role.name
  policy_arn = aws_iam_policy.pdfviewer_ec2_instance_policy.arn
}

data "aws_iam_policy" "oit_infra_cloudwatch_policy_arn" {
  name = var.iam_instance_profile_policy
}

resource "aws_iam_role_policy_attachment" "pdfviewer_ec2_instance_policy_attachment_two" {
  role       = aws_iam_role.pdfviewer_ec2_instance_role.name
  policy_arn = data.aws_iam_policy.oit_infra_cloudwatch_policy_arn.arn
}
