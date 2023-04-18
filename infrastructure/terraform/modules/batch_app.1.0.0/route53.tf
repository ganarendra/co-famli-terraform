resource "aws_route53_record" "batch_service_route53_record_entry" {
  zone_id = var.hosted_zone_id
  name    = "batch.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.batch_app_elb.dns_name]
}
