resource "aws_security_group" "dms_replication_instance_sg" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.database_subnets).*.cidr_block, var.workstation_subnets, ["10.51.27.12/32"])
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-dms-sg" })
}
