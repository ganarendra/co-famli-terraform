resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = var.tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecr_repository" "foo" {
  #checkov:skip=CKV_AWS_51:Ensure ECR Image Tags are immutable
  lifecycle {
    ignore_changes = [
      encryption_configuration
    ]
  }
  image_scanning_configuration {
    scan_on_push = true
  }

  name                 = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_ecr_arn
  }
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_microservices_repo" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.ecs_task_execution_iam_role.arn,
        data.aws_iam_role.deployment_sso_role.arn
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
  repository = aws_ecr_repository.foo.name
  policy     = data.aws_iam_policy_document.ecs_microservices_repo.json
}