resource "aws_synthetics_canary" "ecs_endpoint_canaries" {
  name                 = var.canary_name
  artifact_s3_location = "s3://${data.aws_s3_bucket.canary_scripts.id}"
  execution_role_arn   = "${data.aws_iam_role.canary_scripts_s3_role.arn}"
  runtime_version      = "syn-python-selenium-1.0"
  zip_file             = "canary_execution.zip"
  handler              = "exports.handler"
  schedule {
    expression = "rate(5 minutes)"
  }
  success_retention_period = 450
  failure_retention_period = 450
  count = length(var.task_defination_arns)
  # run_config {
  #   ecs_fargate {
  #     task_definition_arn = element(var.task_definition_arns, count.index)
  #     subnets_ids         = var.subnets_ids
  #     count = length (var.aws_security_group_ids)
  #     security_groups_ids = element(var.aws_security_group_ids, count.index)
  #   }
  # }
}