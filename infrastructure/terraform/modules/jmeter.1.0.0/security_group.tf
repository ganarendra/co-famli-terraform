resource "aws_security_group" "ec2_instance_security_group" {
  #checkov:skip=CKV_AWS_277:Ensure no security groups allow ingress from 0.0.0.0:0 to port -1
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  #checkov:skip=CKV_AWS_25:Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389
  #checkov:skip=CKV_AWS_24:Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name   = "${var.instance_name}-sg"
  tags   = var.tags
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(values(data.aws_subnet.app_subnet_ids).*.cidr_block)
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = concat(values(data.aws_subnet.app_subnet_ids).*.cidr_block)
    }
  }

  #  egress {
  #   description = "TLS from VPC"
  #   from_port   = 49152
  #   to_port     = 65535
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rdp_ec2_instance_security_group" {
  #checkov:skip=CKV_AWS_277:Ensure no security groups allow ingress from 0.0.0.0:0 to port -1
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  #checkov:skip=CKV_AWS_25:Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389
  #checkov:skip=CKV_AWS_24:Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name   = "${var.instance_name}-sg"
  tags   = var.tags
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = 3389
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(values(data.aws_subnet.app_subnet_ids).*.cidr_block, var.workstation_subnets)
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
