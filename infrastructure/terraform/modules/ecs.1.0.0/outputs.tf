output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "load_balancer_security_group_id" {
  value = aws_security_group.lb_security_group.id
}

output "lb_log_s3_bucket" {
  value = aws_s3_bucket.lb_log_bucket.bucket
}
output "task_defination_arn" {
  value = aws_ecs_task_definition.task.arn
}
output "aws_security_group" {
  value = aws_security_group.ecs_task_security_group.id
}