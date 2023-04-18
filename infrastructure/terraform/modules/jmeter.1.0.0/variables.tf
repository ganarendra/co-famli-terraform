variable "master_node_ami_id" {
  description = ""
  type        = string
}

variable "agent_node_admi_id" {
  description = ""
  type        = string
}

variable "secretsmanager_kms_arn" {
  description = ""
  type        = string
}

variable "number_of_agents" {
  description = ""
  type        = number
}

variable "subnet_ids" {
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

variable "ingress_cidr_ranges" {
  description = ""
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "iam_instance_profile_policy" {
  description = ""
  type        = string
}

variable "deployment_sso_role_name" {
  description = ""
  type        = string
}

variable "workstation_subnets" {
  description = ""
  type        = list(string)
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "app_subnets" {
  description = ""
  type        = list(string)
}
