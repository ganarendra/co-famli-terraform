variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "kms_sns_arn" {
  description = ""
  type        = string
}
