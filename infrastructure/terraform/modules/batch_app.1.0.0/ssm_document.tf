resource "random_string" "ssm_doc_name_suffix" {
  length  = 6
  special = false
}

resource "aws_ssm_document" "batch_application_deployment_ec2" {
  name          = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app-deployment"
  document_type = "Command"

  content = jsonencode({
    "schemaVersion" = "2.2",
    "description"   = "Example SSM Document",
    "parameters" = {
      "commands" = {
        "type" = "StringList"
      }
    },
    "mainSteps" = [
      {
        "action" = "aws:runPowerShellScript",
        "name"   = "example",
        "inputs" = {
          "timeoutSeconds" = "300",
          "runCommand" = [
            "$env:Path = [System.Environment]::GetEnvironmentVariable(\"Path\",\"Machine\")",
            "aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com",
            "docker ps -q | % { docker stop $_ }",
            "msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi",
            # "Remove-Item -Recurse -Force C:\\Users\\AdminBatch\\Desktop\\Batch.BatchProcess.Producer",
            "aws s3 sync s3://${aws_s3_bucket.batch_application_deployment.id} C:\\Users\\AdminBatch\\Desktop\\ --delete --exact-timestamps",
            "docker pull ${aws_ecr_repository.batch_web_repo.repository_url}:batchlistener-container-latest",
            "docker pull ${aws_ecr_repository.batch_web_repo.repository_url}:batchweb-container-latest",
            "docker run -d --hostname ${var.batch_listener_hostname} ${aws_ecr_repository.batch_web_repo.repository_url}:batchlistener-container-latest",
            "docker run -p 443:443 -d -v c:\\Users\\AdminBatch\\Desktop:c:\\producer ${aws_ecr_repository.batch_web_repo.repository_url}:batchweb-container-latest"
            # "wget https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi -OutFile amazon-cloudwatch-agent.msi",
            # "msiexec /i amazon-cloudwatch-agent.msi",
            # "& \"C:\\Program Files\\Amazon\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent-ctl.ps1\" -a fetch-config -m ec2 -s -c file:C:\\Users\\AdminBatch\\Desktop\\amazon-logs-agent-config.json"
          ]
        }
      }
    ]
  })
}
