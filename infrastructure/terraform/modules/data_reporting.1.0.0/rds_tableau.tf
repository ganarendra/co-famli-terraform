resource "aws_db_instance" "default" {
  #checkov:skip=CKV_AWS_161:Ensure RDS database has IAM authentication enabled 
  tags                       = var.tags
  db_name                    = "cdle"
  identifier                 = var.rds_instance_name
  allocated_storage          = var.storage_size
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  multi_az                   = true
  monitoring_interval        = 5
  auto_minor_version_upgrade = true
  monitoring_role_arn        = aws_iam_role.rds_monitoring_instance_role.arn
  username                   = "root"
  password                   = random_password.rds_password.result
  copy_tags_to_snapshot      = true
  skip_final_snapshot        = true
  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"]
  db_subnet_group_name       = aws_db_subnet_group.famli_db_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.rds_security_group.id]
  kms_key_id                 = data.aws_kms_key.rds.arn
  storage_encrypted          = true
  deletion_protection        = true
  parameter_group_name       = aws_db_parameter_group.default.name
  snapshot_identifier        = var.restore_from_snapshot ? var.db_snapshot_identifier_id : null
}

resource "aws_db_parameter_group" "default" {
  name   = "${var.rds_instance_name}-pg"
  family = "mysql8.0"

  parameter {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "binlog_row_image"
    value        = "Full"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "binlog_checksum"
    value        = "NONE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "local_infile"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_subnet_group" "famli_db_subnet_group" {
  tags       = var.tags
  subnet_ids = var.database_subnet_ids
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.rds_instance_name}-rds-sec-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.database_subnets).*.cidr_block, var.workstation_subnets, ["10.51.27.12/32"])
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.rds_instance_name })
}

# resource "aws_db_proxy" "famli_rds_proxy" {
#   depends_on = [
#     aws_db_instance.default,
#     aws_security_group.rds_security_group
#   ]
#   name                   = "${var.rds_instance_name}-db-proxy"
#   debug_logging          = true
#   engine_family          = "MYSQL"
#   idle_client_timeout    = 1800
#   require_tls            = false
#   vpc_subnet_ids         = var.database_subnet_ids
#   vpc_security_group_ids = [aws_security_group.rds_security_group.id]
#   role_arn               = aws_iam_role.rds_proxy_iam_role.arn

#   auth {
#     auth_scheme = "SECRETS"
#     iam_auth    = "DISABLED"
#     secret_arn  = aws_secretsmanager_secret.famli-rds-secret.arn
#   }
# }

# resource "aws_db_proxy_default_target_group" "famli_rds_proxy_target_group" {
#   db_proxy_name = aws_db_proxy.famli_rds_proxy.name

#   connection_pool_config {
#     max_connections_percent = 100
#   }
# }

# resource "aws_db_proxy_target" "famli_rds_proxy_db_target" {
#   db_instance_identifier = aws_db_instance.default.id
#   db_proxy_name          = aws_db_proxy.famli_rds_proxy.name
#   target_group_name      = aws_db_proxy_default_target_group.famli_rds_proxy_target_group.name
# }

# resource "aws_iam_role" "rds_proxy_iam_role" {
#   name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-tableau-proxy-role"
#   assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
# }

resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "random_password" "rds_secret_name_suffix" {
  length  = 4
  special = false
}

resource "aws_secretsmanager_secret" "famli-rds-secret" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  lifecycle {
    ignore_changes = [
      name
    ]
  }
  kms_key_id = var.secretsmanager_kms_arn
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-reporting-db-${random_password.rds_secret_name_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "famli_rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.famli-rds-secret.id
  secret_string = jsonencode({ username = "root", password = random_password.rds_password.result })
}

# resource "aws_iam_policy" "rds_proxy_policy" {
#   policy = data.aws_iam_policy_document.this.json
#   name   = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-reporting-proxy-policy"
# }

# resource "aws_iam_role_policy_attachment" "rds-policy-attachment" {
#   role       = aws_iam_role.rds_proxy_iam_role.name
#   policy_arn = aws_iam_policy.rds_proxy_policy.arn
# }

# data "aws_iam_policy_document" "this" {

#   statement {
#     sid = "AllowRdsToGetSecretValueFromSecretsManager"

#     actions = [
#       "secretsmanager:GetSecretValue"
#     ]

#     resources = [aws_secretsmanager_secret.famli-rds-secret.arn]
#   }

#   statement {
#     sid = "AllowRdsToUseKmsKeyToDecryptSecretValuesInSecretsManager"

#     actions = [
#       "kms:Decrypt"
#     ]

#     resources = [
#       data.aws_kms_key.sm.arn
#     ]

#     condition {
#       test     = "StringEquals"
#       values   = [format("secretsmanager.%s.amazonaws.com", join("", data.aws_region.this.*.name))]
#       variable = "kms:ViaService"
#     }
#   }
# }
