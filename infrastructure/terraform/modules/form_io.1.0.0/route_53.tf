resource "aws_route53_record" "form_service_route53_record_entry" {
  zone_id = var.hosted_zone
  name    = "fmio.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.formio.cname]
}

resource "aws_route53_record" "formio_acm_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.formio_service_certificate.domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.hosted_zone
}
