variable "vpc_id" {
  description = ""
  type        = string
}

variable "database_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "web_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "app_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "workstation_subnets" {
  description = "CIDR block on AWS Work Stations"
  type        = list(string)
}

variable "hosted_zone_id" {
  description = "route 53 hosted zone id"
  type        = string
}

variable "root_domain_name" {
  description = ""
  type        = string
}

variable "deployment_sso_role_name" {
  description = ""
  type        = string
}

variable "oit_support_role" {
  description = ""
  type        = string
}

variable "oit_support_policy" {
  description = ""
  type        = string
}

variable "control_tower_sso_infra_iam_role" {
  description = ""
  type        = string
}
