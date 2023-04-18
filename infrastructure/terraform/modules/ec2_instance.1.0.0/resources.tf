resource "aws_network_interface" "ec2" {
  count     = length(var.subnet_ids)
  subnet_id = var.subnet_ids[count.index]

  depends_on = [
    aws_security_group.ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.ec2_instance_security_group.id]
}

resource "aws_instance" "ec2" {
  #checkov:skip=CKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances //All the ec2 instances are for non prod environments. 
  lifecycle {
    ignore_changes = [
      ebs_optimized
    ]
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
  ebs_optimized = true
  count                = length(var.subnet_ids)
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.id
  root_block_device {
    volume_size = 250
  }
  network_interface {
    network_interface_id = aws_network_interface.ec2[count.index].id
    device_index         = 0
  }

  tags = merge(var.tags, { Name = var.instance_name })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_instance_profile_${var.tags.environment}_${random_password.iam_instance_profile_name_prefix.result}"
  role = var.iam_instance_profile
}
resource "random_password" "iam_instance_profile_name_prefix" {
  length  = 4
  special = false
}
