resource "aws_route53_record" "service_route53_record_entry" {
  depends_on = [
    aws_network_interface.ec2,
    aws_instance.ec2
  ]
  zone_id = var.hosted_zone_id
  name    = "sonarqube.cdle.famli.${var.application_root_domain}"
  type    = "A"
  ttl     = 60
  records = [data.aws_network_interface.nic.private_ip]
}

data "aws_network_interface" "nic" {
  id = aws_instance.ec2.primary_network_interface_id
}
