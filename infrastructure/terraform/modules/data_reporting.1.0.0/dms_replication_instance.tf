resource "aws_dms_replication_instance" "test" {
  #checkov:skip=CKV2_AWS_12:Ensure EBS Volume is encrypted by KMS using a customer managed Key (CMK)
  #checkov:skip=CKV_AWS_212:Ensure EBS Volume is encrypted by KMS using a customer managed Key (CMK)
  depends_on = [
    aws_db_instance.default,
  ]
  allocated_storage          = var.storage_size
  apply_immediately          = true
  auto_minor_version_upgrade = true
  availability_zone          = var.dms_replication_instance_availability_zone
  engine_version             = "3.4.7"
  multi_az                   = false
  # kms_key_arn = var.kms_ebs_arn
  preferred_maintenance_window = "sun:10:30-sun:14:30"
  publicly_accessible          = false
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-replication-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id

  tags = {
    Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-replication-instance"
  }

  vpc_security_group_ids = [
    aws_security_group.dms_replication_instance_sg.id,
  ]
}

resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-subnet-group"
  replication_subnet_group_id          = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-subnet-group"

  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-subnet-group"
  }
}
