output "rds_credentials_secret_arn" {
  value = aws_secretsmanager_secret.famli-rds-secret.arn
}

output "rds_credentials_secret_name" {
  value = aws_secretsmanager_secret.famli-rds-secret.name
}

output "rds_host_name" {
  value = aws_db_proxy.famli_rds_proxy.endpoint
}
