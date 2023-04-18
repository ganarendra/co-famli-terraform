resource "aws_acm_certificate" "ecs_service_certificate" {
  count = length(var.services)
  lifecycle {
    create_before_destroy = true
  }
  domain_name       = "${var.services[count.index]}.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  validation_method = "DNS"
}

locals {
  dvo = flatten(aws_acm_certificate.ecs_service_certificate[*].domain_validation_options)
}

resource "aws_route53_record" "service_route53_record_entry" {
  count = var.expose_web == false ? length(var.services) : 0

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.services[count.index]}.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.ecs_service_lb[count.index].dns_name]
}

resource "aws_route53_record" "service_route53_record_entry_web_exposed" {
  count = var.expose_web == true ? length(var.services) : 0

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.services[count.index]}.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.ecs_service_lb_expose_web[count.index].dns_name]
}

resource "aws_route53_record" "record_validation" {
  count = length(var.services)

  depends_on = [
    aws_acm_certificate.ecs_service_certificate
  ]

  allow_overwrite = true
  ttl             = 60
  zone_id         = data.aws_route53_zone.domain.zone_id

  name    = lookup(local.dvo[count.index], "resource_record_name")
  type    = lookup(local.dvo[count.index], "resource_record_type")
  records = [lookup(local.dvo[count.index], "resource_record_value")]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count = length(var.services)

  depends_on = [
    aws_route53_record.record_validation
  ]

  certificate_arn         = aws_acm_certificate.ecs_service_certificate[count.index].arn
  validation_record_fqdns = [aws_route53_record.record_validation[count.index].fqdn]
}
