resource "aws_appautoscaling_target" "dev_to_target" {
  count = length(var.services)

  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.micro_services[count.index].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_memory" {
  count = length(var.services)

  name               = "${var.tags.environment}-scaling-memory-${var.services[count.index]}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "dev_to_cpu" {
  count = length(var.services)

  name               = "${var.tags.environment}-scaling-cpu-${var.services[count.index]}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
