variable "canary_name" {
  description = ""
  type        = string
}
variable "task_defination_arns" {
  description = "aws ecs task definition"
  type        = list(string)
}
variable "subnets_ids" {
  description = ""
  type        = list(string)
}
variable "aws_security_group_ids" {
  description = ""
  type        = list(string)
}
variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

