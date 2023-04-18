resource "aws_docdb_cluster" "docdb" {

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      kms_key_id
    ]
  }

  cluster_identifier      = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-form-io"
  engine                  = "docdb"
  master_username         = "formio"
  enabled_cloudwatch_logs_exports  = ["audit", "profiler"]
  master_password         = random_password.form_io_docdb_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  kms_key_id              = var.kms_docdb_arn
  skip_final_snapshot     = true
  storage_encrypted       = true
  apply_immediately       = true
  db_subnet_group_name    = aws_docdb_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.doc_db_security_group.id]
}

resource "random_password" "form_io_docdb_password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {

  depends_on = [
    aws_docdb_cluster.docdb
  ]

  lifecycle {
    ignore_changes = [
      identifier,
    ]
    prevent_destroy = true
  }

  count              = 2
  identifier         = "docdb-cluster-formio-${var.tags.environment}-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_subnet_group" "default" {
  name       = "formio-subnet-group-${var.tags.environment}"
  subnet_ids = concat(values(data.aws_subnet.app_subnets).*.id)
}


resource "aws_security_group" "doc_db_security_group" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-docdb-formio-sg"
  description = "Allow TLS inbound traffic from app subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-task-sg" })
}
