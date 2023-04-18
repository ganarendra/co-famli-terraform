resource "aws_security_group" "redis_security_group" {
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name        = "${var.cluster_id}-sg"
  tags        = var.tags
  vpc_id      = var.vpc_id
  description = "security group for redis"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block, var.workstation_subnets)
    }
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "app_subnets" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}