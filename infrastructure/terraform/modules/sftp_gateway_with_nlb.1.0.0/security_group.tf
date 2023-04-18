resource "aws_security_group" "aws_transfer_family_security_group" {
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-server-sg"
  description = "SFTP transfer server sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.web_subnet_ids).*.cidr_block, var.workstation_subnets, var.remote_users_whitelist)
  }

  egress {
    description = "Outbound from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-sftp-sg" })
}
