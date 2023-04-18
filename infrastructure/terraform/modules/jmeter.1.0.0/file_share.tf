resource "aws_directory_service_directory" "ad" {
  name     = "corp.${var.application_root_domain}"
  password = "SuperSecretPassw0rd"
  size     = "Small"
  type = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.app_subnets
  }
}

resource "aws_fsx_windows_file_system" "example" {
  depends_on = [
    aws_security_group.ec2_instance_security_group
  ]
  #checkov:skip=CKV_AWS_179:Ensure FSX Windows filesystem is encrypted by KMS using a customer managed Key (CMK)
  active_directory_id = aws_directory_service_directory.ad.id
  storage_capacity    = 300
  subnet_ids          = var.app_subnets
  throughput_capacity = 2048
  deployment_type = "MULTI_AZ_1"
  security_group_ids = [aws_security_group.ec2_instance_security_group.id]
  preferred_subnet_id = "subnet-0692c83098af1580b"
}