resource "aws_security_group" "ec2_instance_security_group" {
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name   = "${var.instance_name}-sg"
  tags   = var.tags
  vpc_id = var.vpc_id
  description = "TLS"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(var.ingress_cidr_ranges, var.workstation_subnets)
    }
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 2300
    to_port     = 2300
    protocol    = "tcp"
    cidr_blocks = ["165.127.63.69/32", "10.51.2.35/32"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 8871
    to_port     = 8871
    protocol    = "tcp"
    cidr_blocks = ["165.127.63.69/32", "10.51.2.35/32"]
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "batch_app_lb_security_group" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app-lb-sg"
  description = "Batch Application Load Balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnet_ids).*.cidr_block, var.workstation_subnets)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnet_ids).*.cidr_block, var.workstation_subnets)
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-batch-app-lb-sg" })
}
