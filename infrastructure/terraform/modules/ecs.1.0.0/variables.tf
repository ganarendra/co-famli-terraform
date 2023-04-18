variable "cluster_name" {
  description = ""
  type        = string
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "services" {
  description = "List of services hosted in ecs"
  type        = list(string)
}

variable "subnets" {
  description = ""
  type        = list(string)
}

variable "web_subnet" {
  description = ""
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "application_root_domain" {
  description = ""
  type        = string
}

# variable "application_route53_hosted_zone_id" {
#   description = ""
#   type        = string
# }

variable "db_subnets" {
  description = ""
  type        = list(string)
}

variable "deployment_sso_role_name" {
  description = ""
  type        = string
}

variable "ports" {
  description = "List of ports hosted in ecs"
  type        = list(number)
}

variable "health_check_protocol" {
  description = ""
  type        = list(string)
}

# variable "Internal" {
#   description = ""
#   type        = list(string)
# }

variable "expose_web" {
  description = ""
  type        = bool
}

variable "uat_tester_ips" {
  description = ""
  type        = list(string)
  default     = []
}

variable "workstation_subnets" {
  description = ""
  type        = list(string)
  default     = []
}

variable "kms_s3_arn" {
  description = "s3 kms key arn"
  type        = string
}

variable "kms_cloudwatch_arn" {
  description = ""
  type        = string
}

variable "kms_ecr_arn" {
  description = ""
  type        = string
}

variable "kms_cloudwatch_id" {
  description = ""
  type        = string
}

variable "secretsmanager_kms_arn" {
  description = ""
  type        = string
}