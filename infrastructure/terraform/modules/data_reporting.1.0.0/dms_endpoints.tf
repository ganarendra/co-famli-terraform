resource "aws_dms_endpoint" "target" {
  #checkov:skip=CKV2_AWS_49:Ensure AWS Database Migration Service endpoints have SSL configured
  depends_on = [
    aws_db_instance.default
  ]
  endpoint_id                 = "${var.rds_instance_name}-target-db"
  endpoint_type               = "target"
  engine_name                 = "mysql"
  password                    = jsondecode(aws_secretsmanager_secret_version.famli_rds_secret_version.secret_string)["password"]
  port                        = 3306
  kms_key_arn = aws_kms_key.dms_endpoint_kms.arn
  extra_connection_attributes = "initstmt=SET FOREIGN_KEY_CHECKS=0"
  server_name                 = aws_db_instance.default.address
  ssl_mode                    = "none"
  username                    = jsondecode(aws_secretsmanager_secret_version.famli_rds_secret_version.secret_string)["username"]

  tags = {
    Name = "${var.rds_instance_name}-target-db"
  }
}

resource "aws_dms_endpoint" "source" {
  #checkov:skip=CKV2_AWS_49:Ensure AWS Database Migration Service endpoints have SSL configured
  endpoint_id   = "${var.rds_instance_name}-source-db"
  endpoint_type = "source"
  engine_name   = "mysql"
  password      = jsondecode(data.aws_secretsmanager_secret_version.source_db_secret.secret_string)["password"]
  port          = 3306
  kms_key_arn = aws_kms_key.dms_endpoint_kms.arn
  server_name   = var.source_db_hostname
  ssl_mode      = "none"
  username      = jsondecode(data.aws_secretsmanager_secret_version.source_db_secret.secret_string)["username"]

  tags = {
    Name = "${var.rds_instance_name}-source-db"
  }
}
