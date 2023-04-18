resource "aws_security_group" "ecs_task_security_group" {
  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-formio-sg"
  description = "Allow TLS inbound traffic from app subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block, var.workstation_subnets)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 4005
    to_port     = 4005
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }


  ingress {
    description = "TLS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
  }


  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-task-sg" })
}
