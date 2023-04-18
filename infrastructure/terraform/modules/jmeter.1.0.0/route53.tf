resource "aws_route53_record" "jmeter_agent_service_route53_record_entry" {
  count = var.number_of_agents

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "jmeter-${count.index}.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_instance.ec2_jmeter_worker[count.index].private_ip]
}

resource "aws_route53_record" "jmeter_master_service_route53_record_entry" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "jmeter-master.service.${var.tags.environment}.cdle.famli.${var.application_root_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [aws_instance.ec2_jmeter_master.private_ip]
}
