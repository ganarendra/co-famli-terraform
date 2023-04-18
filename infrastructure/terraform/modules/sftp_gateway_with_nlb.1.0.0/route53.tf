resource "aws_route53_record" "aws_transfer_service_route53_record_entry" {
  depends_on = [
    aws_transfer_server.sftp_gateway
  ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "sftp.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_transfer_server.sftp_gateway.endpoint]
}
