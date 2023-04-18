variable "instance_name" {
  description = ""
  type        = string
}

variable "app_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "database_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "secretsmanager_kms_arn" {
  description = ""
  type        = string
}

variable "storage_size" {
  description = ""
  type        = number
}

variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "workstation_subnets" {
  description = ""
  type        = list(string)
}

variable "hosted_zone_id" {
  description = ""
  type        = string
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "control_tower_sso_infra_iam_role" {
  description = ""
  type        = string
}

# variable "enable_db_reader_user" {
#   description = ""
#   type        = bool
#   default     = false
# }

# variable "db_reader_user_name" {
#   description = ""
#   type        = string
#   default     = "reader"
# }

# variable "db_reader_user_password" {
#   description = ""
#   type        = string
#   default     = "deloitte"
# }

# variable "db_reader_user_password_generate_random" {
#   description = ""
#   type        = bool
#   default     = false
# }
