variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "cluster_id" {
  description = ""
  type        = string
}

variable "app_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id that the ec2 instance is deployed into"
  type        = string
}

variable "ingress_ports" {
  description = "list of ports the ec2 instance will accept traffic from"
  type        = list(string)
}

variable "egress_ports" {
  description = "list of ports the ec2 instance will allow output traffic to"
  type        = list(string)
}

variable "egress_cidr_ranges" {
  description = ""
  type        = list(string)
}

variable "workstation_subnets" {
  description = ""
  type        = list(string)
}