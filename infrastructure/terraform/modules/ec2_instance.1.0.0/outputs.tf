output "ec2_instances" {
  value = [for s in aws_instance.ec2 : s.id]
}
