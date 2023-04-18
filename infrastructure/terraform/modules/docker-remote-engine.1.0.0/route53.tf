resource "aws_route53_record" "form_service_route53_record_entry" {
  zone_id = var.hosted_zone_id
  name    = "docker.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.ec2.private_ip]
}
