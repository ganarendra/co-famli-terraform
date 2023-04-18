resource "aws_elb" "pdf_reactor_elb" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdf-reactor"
  availability_zones = ["us-east-1a"]
  security_groups    = [aws_security_group.pdF_reactor_lb_security_group.id]

  listener {
    instance_port     = 9423
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:9432/"
    interval            = 30
  }

  instances = [aws_instance.ec2.id]

}

resource "aws_security_group" "pdF_reactor_lb_security_group" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdf-react-sg"
  description = "Pdf Reactor Load Balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 9423
    to_port     = 9423
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

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-pdf-reactor-lb" })
}
