variable "region" {
  type        = string
  description = "the aws region where resources will be deployed"
  default     = "us-east-1"
}

variable "agency" {
  type        = string
  description = "the agency"
  default     = "oit"
}

variable "project" {
  type        = string
  description = "the project"
  default     = "famli"
}

variable "environment" {
  type        = string
  description = "the environment (d = dev, t = test, p = prod)"
  default     = "p"
}

variable "fundingrequest" {
  type        = string
  description = "the funding request that will pay for the project resources"
  default     = "FR97483"
}

variable "po" {
  type        = string
  description = "the po or division string for the project"
  default     = "EGB2022-CDLE-FAMLI"
}

variable "dataclass" {
  type        = string
  description = "the dataclass for the project data (pii, phi, cjis, etc)"
  default     = "notset"
}

variable "division" {
  type        = string
  description = "the dataclass for the project data (pii, phi, cjis, etc)"
  default     = "KFAM"
}
