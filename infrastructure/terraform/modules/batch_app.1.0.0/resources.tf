resource "aws_network_interface" "ec2" {
  subnet_id = var.subnet_ids

  depends_on = [
    aws_security_group.ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.ec2_instance_security_group.id]
}

resource "random_password" "ec2_batch_rdp_password" {
  length  = 16
  special = false
}

resource "random_password" "ec2_secret_name_suffix" {
  length  = 4
  special = false
}

resource "aws_secretsmanager_secret" "ec2_batch_app_rdp_credentials" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  lifecycle {
    ignore_changes = [
      name
    ]
  }
  kms_key_id = var.secretsmanager_kms_arn
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-rdp-user-${random_password.ec2_secret_name_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "famli_rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.ec2_batch_app_rdp_credentials.id
  secret_string = jsonencode({ username = "AdminBatch", password = random_password.ec2_batch_rdp_password.result })
}


resource "aws_instance" "ec2" {
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  lifecycle {
    ignore_changes = [
      ebs_optimized
    ]
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  ebs_optimized = true

  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.batch_ec2_instance_profile.id
  user_data            = <<EOT
<powershell>
New-LocalUser -Name "AdminBatch" -Password (ConvertTo-SecureString "${random_password.ec2_batch_rdp_password.result}" -AsPlainText -Force) -FullName "AdminBatch"
Add-LocalGroupMember -Group "Users" -Member "AdminBatch"
Add-LocalGroupMember -Group "Administrators" -Member "AdminBatch"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "AdminBatch"
</powershell>
EOT
  root_block_device {
    volume_size = 250
  }
  network_interface {
    network_interface_id = aws_network_interface.ec2.id
    device_index         = 0
  }

  tags = merge(var.tags, { Name = var.instance_name })
}
