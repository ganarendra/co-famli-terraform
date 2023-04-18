resource "aws_ecr_repository" "batch_web_repo" {
  #checkov:skip=CKV_AWS_51:Ensure ECR Image Tags are immutable
  lifecycle {
    ignore_changes = [
      encryption_configuration
    ]
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  name                 = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-web-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_ecr_arn
  }
}

data "aws_iam_policy_document" "batch_web_repo_policy" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.batch_ec2_instance_role.arn,
        data.aws_iam_role.deployment_sso_role_name.arn
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "batch_web_repo_policy_policy" {
  repository = aws_ecr_repository.batch_web_repo.name
  policy     = data.aws_iam_policy_document.batch_web_repo_policy.json
}