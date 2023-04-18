variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "application_root_domain" {
  description = ""
  type        = string
}

variable "kms_s3_arn" {
  description = "s3 kms key arn"
  type        = string
}