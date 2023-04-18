variable "agency_name" {
  type        = string
  description = "the three or four letter acronym of the agency, e.g. cdhs, cdot, dnr"
}

variable "project_name" {
  type        = string
  description = "the name of the project, e.g. fueltax, tableau, mycolorado"
}

variable "environment_name" {
  type        = string
  description = "the name of the environment, one of d, t, p, r, m, u"
}

# variable "division_name" {
#   description = "the 4 letter division name"
#   default     = "notset"
# }

#variable "scheduled" {
#  description = "shut off resources after work hours"
#  default     = "true"
#}

# variable "dataclass_name" {
#   type = string
#   description = "reflects the type of data at rest, one of cjis, fti, hipaa, pci, pii, none"
#   default     = "none"
# }

variable "fundingrequest_name" {
  type        = string
  description = "the funding request number"
  default     = "notset"
}

variable "sharedcostgroup_name" {
  type        = string
  description = "if sharing costs, group name"
  default     = "na"
}

variable "po_name" {
  type        = string
  description = "name of the po to charge against"
  #default     = "notset"
}

# variable "poprevious_name" {
#   description = "name of the previous po that was charged against - necessary for billing to catch up with po changes"
#   default     = "notset"
# }

variable "backupdays" {
  type        = string
  description = "Number of days that the resource is to be backed up"
  default     = "30"
}
