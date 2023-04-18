resource "aws_security_group" "ec2_instance_security_group" {
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
      cidr_blocks = var.ingress_cidr_ranges
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
