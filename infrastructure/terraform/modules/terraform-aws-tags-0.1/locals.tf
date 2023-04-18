locals {
  agency_name      = var.agency_name
  project_name     = var.project_name
  environment_name = var.environment_name
  #division_name        = var.division_name
  #costcenter_name     = var.costcenter_name
  po_name = var.po_name
  #poprevious_name      = var.poprevious_name
  #iapo_name           = var.iapo_name
  fundingrequest_name  = var.fundingrequest_name
  sharedcostgroup_name = var.sharedcostgroup_name
  #scheduled            = var.scheduled
  #dataclass_name       = var.dataclass_name
  backupdays = var.backupdays
}



locals {
  # Common tags to be assigned to all resources
  common_tags = {
    agency      = local.agency_name
    project     = local.project_name
    environment = local.environment_name
    #division        = local.division_name
    #costcenter     = local.costcenter_name
    po = local.po_name
    #poprevious      = local.poprevious_name
    #iapo           = local.iapo_name
    fundingrequest  = local.fundingrequest_name
    sharedcostgroup = local.sharedcostgroup_name
    #scheduled      = local.scheduled
    #dataclass      = local.dataclass_name
    backupdays = local.backupdays
  }
}
