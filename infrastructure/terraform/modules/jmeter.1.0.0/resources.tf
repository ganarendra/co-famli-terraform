resource "aws_network_interface" "ec2_jmeter_master" {
  subnet_id = var.subnet_ids

  depends_on = [
    aws_security_group.rdp_ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.rdp_ec2_instance_security_group.id]
}

resource "aws_network_interface" "ec2_jmeter_agent" {
  count = var.number_of_agents 

  subnet_id = var.subnet_ids

  depends_on = [
    aws_security_group.rdp_ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.rdp_ec2_instance_security_group.id]
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
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-jmeter-master-rdp-user-${random_password.ec2_secret_name_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "famli_rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.ec2_batch_app_rdp_credentials.id
  secret_string = jsonencode({ username = "Admin", password = random_password.ec2_batch_rdp_password.result })
}


resource "aws_instance" "ec2_jmeter_master" {
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  lifecycle {
    ignore_changes = [
      ebs_optimized
    ]
  }
  ebs_optimized        = true
  ami                  = var.master_node_ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.jmeter_ec2_instance_profile.id
  user_data            = <<EOT
<powershell>
New-LocalUser -Name "Admin" -Password (ConvertTo-SecureString "${random_password.ec2_batch_rdp_password.result}" -AsPlainText -Force) -FullName "AdminBatch"
Add-LocalGroupMember -Group "Users" -Member "Admin"
Add-LocalGroupMember -Group "Administrators" -Member "Admin"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "Admin"
</powershell>
EOT
  root_block_device {
    volume_size = 250
  }
  network_interface {
    network_interface_id = aws_network_interface.ec2_jmeter_master.id
    device_index         = 0
  }

  tags = merge(var.tags, { Name = "${var.instance_name}-master" })
}

resource "aws_instance" "ec2_jmeter_worker" {
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  ebs_optimized = true
  count         = var.number_of_agents

  ami                  = var.agent_node_admi_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.jmeter_ec2_instance_profile.id
  user_data            = <<EOT
<powershell>
New-LocalUser -Name "Admin" -Password (ConvertTo-SecureString "${random_password.ec2_batch_rdp_password.result}" -AsPlainText -Force) -FullName "AdminBatch"
Add-LocalGroupMember -Group "Users" -Member "Admin"
Add-LocalGroupMember -Group "Administrators" -Member "Admin"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "Admin"
</powershell>
EOT
  root_block_device {
    volume_size = 250
  }
  network_interface {
    network_interface_id = aws_network_interface.ec2_jmeter_agent[count.index].id
    device_index         = 0
  }

  tags = merge(var.tags, { Name = "${var.instance_name}-worker-${count.index}" })
}
