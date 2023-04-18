resource "random_string" "ssm_doc_name_suffix" {
  length  = 6
  special = false
}

resource "aws_ssm_document" "pdf_viewer_formio_deployment" {
  name          = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdf-viewer-deployment"
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
        "action" = "aws:runShellScript",
        "precondition" = {
          "StringEquals" = [
            "platformType",
            "Linux"
          ]
        },
        "name" = "example",
        "inputs" = {
          "timeoutSeconds" = "300",
          "runCommand" = [
            "service nginx stop",
            "aws s3 sync s3://${aws_s3_bucket.formio_pdfviewer.id} /usr/share/nginx/html",
            "chmod -R 777 /usr/share/nginx/html",
            "service nginx start"
          ]
        }
      }
    ]
  })
}
