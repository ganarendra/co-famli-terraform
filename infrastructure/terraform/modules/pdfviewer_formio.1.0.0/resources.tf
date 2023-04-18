resource "aws_network_interface" "ec2" {
  subnet_id = var.subnet_id

  depends_on = [
    aws_security_group.ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.ec2_instance_security_group.id, aws_security_group.pdfviewer_lambda_sg.id]
}

resource "aws_instance" "ec2" {
  #checkov:skip=CKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  lifecycle {
    ignore_changes = [
      ebs_optimized
    ]
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
  ebs_optimized        = true
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.pdfviewer_ec2_instance_profile.id
  user_data            = <<EOT

#!/bin/bash
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent

sudo amazon-linux-extras install -y nginx1
sudo service nginx start

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

resource "aws_iam_instance_profile" "pdfviewer_ec2_instance_profile" {
  name = "ec2_instance_profile_pdfviewer_formio_${var.tags.environment}"
  role = aws_iam_role.pdfviewer_ec2_instance_role.name
}

data "aws_iam_role" "deployment_sso_role_name" {
  name = var.deployment_sso_role_name
}

data "aws_iam_role" "iam_instance_profile" {
  name = var.iam_instance_profile
}

data "aws_iam_policy" "cloudwatch_iam_role" {
  name = var.iam_instance_profile_policy
}
