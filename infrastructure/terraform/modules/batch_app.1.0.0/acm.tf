resource "aws_acm_certificate" "batch_app_acm_certificate" {
  lifecycle {
    create_before_destroy = true
  }
  domain_name       = "batch.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  validation_method = "DNS"
}

resource "aws_route53_record" "batch_app_acm_certificate_validation_route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.batch_app_acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "batch_app_acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.batch_app_acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.batch_app_acm_certificate_validation_route53_record : record.fqdn]
}
