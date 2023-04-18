resource "aws_network_interface" "ec2" {
  subnet_id               = var.subnet_id
  private_ip_list_enabled = true
  depends_on = [
    aws_security_group.ec2_instance_security_group
  ]

  tags            = var.tags
  security_groups = [aws_security_group.ec2_instance_security_group.id]
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ec2_instance_security_group.id
  network_interface_id = aws_instance.ec2.primary_network_interface_id
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
    http_tokens = "required"
  }
  ebs_optimized = true
  depends_on = [
    aws_network_interface.ec2
  ]
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id

  user_data = <<EOF
#!/bin/bash
sudo yum install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
EOF
  root_block_device {
    volume_size = var.volume_size
  }

  tags = merge(var.tags, { Name = var.instance_name })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_instance_profile_${var.tags.environment}_${random_string.random_suffix_docker_engine_instance_role.result}"
  role = var.iam_instance_profile
}

resource "random_string" "random_suffix_docker_engine_instance_role" {
  length  = 6
  special = false
}
