resource "aws_security_group" "lb_security_group" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-sg"
  description = "ECS Service loadbalance security group"
  vpc_id      = var.vpc_id

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

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-sg" })
}

resource "aws_security_group" "lb_security_group_expose_web" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-web"
  description = "ECS Service loadbalance security group"
  vpc_id      = var.vpc_id

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

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-sg" })
}

resource "aws_security_group" "lb_security_group_uat_testers" {
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80 //There is no inbound rule here for 0.0.0.0/0 -> this security group is used only in the UAT environments for testing purposes. We whitelist invidivual users ip address to access the application outside of our OIT workstations.
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-uat-tester"
  description = "ECS Service loadbalance security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.uat_tester_ips
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.uat_tester_ips
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-sg" })
}

resource "aws_security_group" "deloitte_vpn_allow_sg_80" {
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80 //There is no inbound rule here for 0.0.0.0/0 -> this security group is used only in the UAT environments for testing purposes. We whitelist invidivual users ip address to access the application outside of our OIT workstations.
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-deloitte-ip-80"
  description = "ECS Service loadbalance security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.159.162.0/24", "10.159.161.0/24","24.206.105.28/32", "24.206.105.29/32", "24.206.66.40/32", "24.206.66.41/32", "24.206.68.40/32", "24.206.68.41/32", "24.206.70.40/32", "24.206.70.41/32", "24.206.71.40/32", "24.206.71.41/32", "24.206.72.40/32", "24.206.72.41/32", "24.206.73.50/32", "24.206.73.51/32", "24.206.76.48/32", "24.206.76.49/32", "24.206.77.40/32", "24.206.77.41/32", "24.206.78.44/32", "24.206.78.45/32", "24.206.80.48/32", "24.206.80.49/32", "24.206.82.51/32", "24.206.82.52/32", "24.206.84.58/32", "24.206.84.59/32", "24.239.131.30/32", "24.239.131.31/32", "24.239.134.30/32", "24.239.134.31/32", "24.239.140.30/32", "24.239.140.31/32", "167.219.88.140/32", "167.219.0.140/32"]
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-deloitte-ip-80" })
}


resource "aws_security_group" "deloitte_vpn_allow_sg_443" {
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80 //There is no inbound rule here for 0.0.0.0/0 -> this security group is used only in the UAT environments for testing purposes. We whitelist invidivual users ip address to access the application outside of our OIT workstations.
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-deloitte-ip-443"
  description = "ECS Service loadbalance security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.159.162.0/24", "10.159.161.0/24","24.206.105.28/32", "24.206.105.29/32", "24.206.66.40/32", "24.206.66.41/32", "24.206.68.40/32", "24.206.68.41/32", "24.206.70.40/32", "24.206.70.41/32", "24.206.71.40/32", "24.206.71.41/32", "24.206.72.40/32", "24.206.72.41/32", "24.206.73.50/32", "24.206.73.51/32", "24.206.76.48/32", "24.206.76.49/32", "24.206.77.40/32", "24.206.77.41/32", "24.206.78.44/32", "24.206.78.45/32", "24.206.80.48/32", "24.206.80.49/32", "24.206.82.51/32", "24.206.82.52/32", "24.206.84.58/32", "24.206.84.59/32", "24.239.131.30/32", "24.239.131.31/32", "24.239.134.30/32", "24.239.134.31/32", "24.239.140.30/32", "24.239.140.31/32", "167.219.88.140/32", "167.219.0.140/32"]
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-lb-deloitte-ip-443" })
}