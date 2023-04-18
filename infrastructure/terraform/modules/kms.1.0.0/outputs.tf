output "ecr_arn" {
  value       = aws_kms_key.ecr_key.arn
  description = "ECR KMS key ARN"
}

output "ecr_id" {
  value       = aws_kms_key.ecr_key.id
  description = "ECR KMS ID"
}

output "ecr_key_id" {
  value       = aws_kms_key.ecr_key.key_id
  description = "ECR KMS key id"
}

output "s3_arn" {
  value       = aws_kms_key.s3_key.arn
  description = "S3 KMS key ARN"
}

output "s3_id" {
  value       = aws_kms_key.s3_key.id
  description = "S3 KMS ID"
}

output "s3_key_id" {
  value       = aws_kms_key.s3_key.key_id
  description = "S3 KMS key id"
}

output "cloudwatch_arn" {
  value       = aws_kms_key.cloudwatch_key.arn
  description = "CloudWatch KMS key ARN"
}

output "cloudwatch_id" {
  value       = aws_kms_key.cloudwatch_key.id
  description = "CloudWatch KMS ID"
}

output "cloudwatch_key_id" {
  value       = aws_kms_key.cloudwatch_key.key_id
  description = "CloudWatch KMS key id"
}

output "secretsmanager_arn" {
  value       = aws_kms_key.secretsmanager_key.arn
  description = "SecretsManager KMS key ARN"
}

output "secretsmanager_id" {
  value       = aws_kms_key.secretsmanager_key.id
  description = "SecretsManager KMS ID"
}

output "secretsmanager_key_id" {
  value       = aws_kms_key.secretsmanager_key.key_id
  description = "SecretsManager KMS key id"
}

output "docdb_arn" {
  value       = aws_kms_key.docdb_key.arn
  description = "DocDB KMS key ARN"
}

output "docdb_id" {
  value       = aws_kms_key.docdb_key.id
  description = "DocDB KMS ID"
}

output "docdb_key_id" {
  value       = aws_kms_key.docdb_key.key_id
  description = "DocDB KMS key id"
}

output "ebs_id" {
  value       = aws_kms_key.ebs_key.id
  description = "EBS KMS ID"
}

output "ebs_arn" {
  value       = aws_kms_key.ebs_key.arn
  description = "EBS KMS arn"
}

output "ebs_key_id" {
  value       = aws_kms_key.ebs_key.key_id
  description = "EBS KMS key id"
}

output "sns_id" {
  value       = aws_kms_key.sns_key.id
  description = "SNS KMS ID"
}

output "sns_arn" {
  value       = aws_kms_key.sns_key.arn
  description = "SNS KMS ID"
}

output "sns_key_id" {
  value       = aws_kms_key.sns_key.key_id
  description = "SNS KMS key id"
}

output "msk_id" {
  value       = aws_kms_key.msk_key.id
  description = "MSK KMS ID"
}

output "msk_key_id" {
  value       = aws_kms_key.msk_key.key_id
  description = "MSK KMS key id"
}

output "msk_key_arn" {
  value       = aws_kms_key.msk_key.arn
  description = "MSK KMS key id"
}

output "firehose_id" {
  value       = aws_kms_key.firehose.id
  description = "Firehose KMS ID"
}

output "firehose_key_id" {
  value       = aws_kms_key.firehose.key_id
  description = "Firehose KMS key id"
}

output "firehose_key_arn" {
  value       = aws_kms_key.firehose.arn
  description = "Firehose KMS ARN"
}
