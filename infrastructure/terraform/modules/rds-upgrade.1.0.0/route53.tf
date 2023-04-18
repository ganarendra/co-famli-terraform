resource "aws_route53_record" "db_proxy_route53_record_entry" {
  zone_id = var.hosted_zone_id
  name    = "db-proxy.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_db_proxy.famli_rds_proxy.endpoint]
}
