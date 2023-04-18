resource "aws_security_group" "ec2_instance_security_group" {
  #checkov:skip=CKV_AWS_23:Ensure every security groups rule has a description //Rule description already exists
  name   = "${var.instance_name}-sg"
  tags   = var.tags
  vpc_id = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block, var.workstation_subnets)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block, var.workstation_subnets)
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
