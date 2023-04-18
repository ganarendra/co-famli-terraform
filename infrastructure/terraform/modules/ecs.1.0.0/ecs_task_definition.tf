resource "aws_ecs_task_definition" "task" {

  count = length(var.services)

  tags = merge(var.tags, { name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}-taskdef" })

  family                   = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}-taskdef"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_iam_role.arn
  task_role_arn            = aws_iam_role.ecs_task_iam_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = var.services[count.index]
      image     = "${aws_ecr_repository.foo.repository_url}:${var.services[count.index]}-container-latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      environment = [
        {
          "name"  = "ASPNETCORE_ENVIRONMENT",
          "value" = "Development"
        }
      ],
      portMappings = [
        {
          containerPort = var.ports[count.index],
          hostPort      = var.ports[count.index]
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "${var.tags.agency}/${var.tags.project}/${var.tags.environment}/${var.services[count.index]}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.services[count.index]
        }
      }
    }
  ])
}
