variable "tags" {
  default     = {}
  description = "Global resource tags"
  type        = map(string)
}

variable "subnets" {
  description = ""
  type        = list(string)
}

variable "ingress_ports" {
  description = "list of ports the ec2 instance will accept traffic from"
  type        = list(string)
}

variable "egress_ports" {
  description = "list of ports the ec2 instance will allow output traffic to"
  type        = list(string)
}

# variable "egress_cidr_ranges" {
#   description = ""
#   type        = list(string)
# }

# variable "ingress_cidr_ranges" {
#   description = ""
#   type        = list(string)
# }

variable "cluster_name" {
  description = ""
  type        = string
}

variable "vpc_id" {
  description = ""
  type        = string
}
# variable "client_subnets" {
#   type    = list(string)
#   default = []
# }

variable "kafka_version" {
  type = string
}

# variable "broker_node" {
#   type    = number
#   default = 2

# }
# variable "provisioned_throughput" {
#   default = true

# }
# variable "volume_throughput" {
#   type    = number
#   default = 1000
# }

variable "volume_size" {
  type    = number
  default = 1000
}

variable "instance_type" {
  type = string
}

variable "replica_multiplier" {
  type        = number
  description = ""
}

variable "workstation_subnets" {
  type        = list(string)
  description = ""
}

variable "kms_msk_arn" {
  description = ""
  type        = string
}