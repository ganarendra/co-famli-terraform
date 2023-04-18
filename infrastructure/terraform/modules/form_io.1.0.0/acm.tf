resource "aws_acm_certificate" "formio_service_certificate" {
  lifecycle {
    create_before_destroy = true
  }
  domain_name       = "fmio.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert_validation" {

  depends_on = [
    aws_route53_record.formio_acm_cert_validation_record
  ]

  certificate_arn         = aws_acm_certificate.formio_service_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.formio_acm_cert_validation_record : record.fqdn]
}
