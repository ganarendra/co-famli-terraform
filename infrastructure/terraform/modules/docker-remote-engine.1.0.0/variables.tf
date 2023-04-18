variable "ami_id" {
  description = ""
  type        = string
}

variable "subnet_id" {
  description = ""
  type        = string
}

variable "instance_type" {
  description = ""
  type        = string
}

variable "instance_name" {
  description = ""
  type        = string
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

variable "ingress_cidr_ranges" {
  description = ""
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "iam_instance_profile" {
  description = ""
  type        = string
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "hosted_zone_id" {
  description = ""
  type        = string
}

variable "volume_size" {
  description = "Ec2 Instance Volume Size"
  type        = number
}