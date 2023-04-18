data "aws_route53_zone" "domain" {
  name         = var.application_root_domain
  private_zone = false
}

data "aws_subnet" "app_subnet_ids" {
  for_each = toset(var.app_subnet_ids)
  id       = each.value
}

data "aws_subnet" "web_subnet_ids" {
  for_each = toset(var.web_subnet_ids)
  id       = each.value
}


data "aws_caller_identity" "current" {}