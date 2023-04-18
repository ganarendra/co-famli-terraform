output "vpc_id" {
  value = var.vpc_id
}

output "database_subnet_ids" {
  value = var.database_subnet_ids
}

output "web_subnet_ids" {
  value = var.web_subnet_ids
}

output "app_subnet_ids" {
  value = var.app_subnet_ids
}

output "root_domain_name" {
  value = var.root_domain_name
}

output "hosted_zone_id" {
  value = var.hosted_zone_id
}

output "deployment_sso_role_name" {
  value = var.deployment_sso_role_name
}

output "oit_support_role" {
  value = var.oit_support_role
}

output "workstation_subnets" {
  value = var.workstation_subnets
}

output "app_subnet_cidir_list" {
  value = concat(values(data.aws_subnet.app_subnets).*.cidr_block)
}

output "oit_support_policy" {
  value = var.oit_support_policy
}

output "control_tower_sso_infra_iam_role" {
  value = var.control_tower_sso_infra_iam_role
}
