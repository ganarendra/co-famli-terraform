variable "hosted_zone" {
  description = ""
  type        = string
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

# variable "domain_name" {
#   description = ""
#   type        = string
# }

variable "secretsmanager_kms_arn" {
  description = ""
  type        = string
}

variable "kms_docdb_arn" {
  description = ""
  type        = string
}

variable "app_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "kms_s3_arn" {
  description = "s3 kms key arn"
  type        = string
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "vpc_id" {
  description = ""
  type        = string
}

# variable "subnets" {
#   description = ""
#   type        = list(string)
# }


variable "workstation_subnets" {
  description = ""
  type        = list(string)
}

variable "portal_enabled" {
  description = ""
  type        = bool
}

# variable "deployment_sso_role_name" {
#   description = ""
#   type        = string
# }
