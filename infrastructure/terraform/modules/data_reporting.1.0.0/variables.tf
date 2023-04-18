variable "rds_instance_name" {
  description = ""
  type        = string
}

variable "database_subnet_ids" {
  description = ""
  type        = list(any)
}

variable "storage_size" {
  description = ""
  type        = number
}

variable "kms_ebs_arn" {
  description = ""
  type        = string
}

variable "secretsmanager_kms_arn" {
  description = ""
  type        = string
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

variable "source_db_hostname" {
  description = ""
  type        = string
}

variable "source_db_secret_arn" {
  description = ""
  type        = string
}

variable "dms_replication_instance_availability_zone" {
  description = ""
  type        = string
}

variable "replication_instance_class" {
  description = ""
  type        = string
}

variable "restore_from_snapshot" {
  description = ""
  type        = bool
  default     = false
}

variable "db_snapshot_identifier_id" {
  description = ""
  type        = string
  default     = ""
}
