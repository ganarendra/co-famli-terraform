data "aws_route53_zone" "domain" {
  name         = var.application_root_domain
  private_zone = false
}

data "aws_caller_identity" "current" {}