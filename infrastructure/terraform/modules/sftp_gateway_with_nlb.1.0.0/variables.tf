variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "app_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "vpc_id" {
  description = ""
  type        = string
}

variable "web_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "workstation_subnets" {
  description = ""
  type        = list(string)
}

variable "remote_users_whitelist" {
  description = ""
  type        = list(string)
  default     = []
}

variable "kms_s3_arn" {
  description = ""
  type        = string
}