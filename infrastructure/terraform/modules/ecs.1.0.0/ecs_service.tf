resource "aws_ecs_service" "micro_services" {

  depends_on = [
    aws_alb_listener.front_end
  ]

  count = length(var.services)

  name                              = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-service-${var.services[count.index]}"
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.task[count.index].arn
  health_check_grace_period_seconds = 240
  desired_count                     = 1
  launch_type                       = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_task_security_group[count.index].id]
  }

  load_balancer {
    container_name   = var.services[count.index]
    target_group_arn = aws_lb_target_group.ecs_service_target_group[count.index].arn
    container_port   = var.ports[count.index]
  }
}

resource "aws_security_group" "ecs_task_security_group" {
  count = length(var.services)

  lifecycle {
    ignore_changes = [
      name
    ]
  }

  name        = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}-task"
  description = "Allow TLS inbound traffic from app subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS Ports from VPC"
    from_port   = var.ports[count.index]
    to_port     = var.ports[count.index]
    protocol    = "tcp"
    cidr_blocks = concat(values(data.aws_subnet.app_subnets).*.cidr_block, values(data.aws_subnet.web_subnet).*.cidr_block, var.workstation_subnets, values(data.aws_subnet.db_subnets).*.cidr_block)
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
