resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}

resource "aws_ses_domain_mail_from" "ses_mail_from_domain" {
  domain           = aws_ses_domain_identity.ses_domain.domain
  mail_from_domain = var.mail
}

resource "aws_route53_record" "ses_domain_mail_from_mx" {
  zone_id = var.hosted_zone
  name    = aws_ses_domain_mail_from.ses_mail_from_domain.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.us-east-1.amazonses.com"] # Change to the region in which `aws_ses_domain_identity.example` is created
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = aws_ses_domain_identity.ses_domain.domain
}

resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = var.hosted_zone
  name    = "${aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = var.hosted_zone
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain.verification_token]
}


resource "aws_ses_domain_identity_verification" "verification" {
  domain = aws_ses_domain_identity.ses_domain.id

  depends_on = [aws_route53_record.amazonses_verification_record]
}
