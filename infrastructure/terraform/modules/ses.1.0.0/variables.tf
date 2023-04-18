variable "domain" {
  description = "domain for ses"
  type        = string
}

variable "mail" {
  description = "email for ses"
  type        = string
}

# variable "tags" {
#   default     = {}
#   description = "Global resource tags"
#   type        = map(string)
# }

variable "hosted_zone" {
  default = ""
  type    = string
}

variable "secretsmanager_kms_arn" {
  default = ""
  type    = string
}
