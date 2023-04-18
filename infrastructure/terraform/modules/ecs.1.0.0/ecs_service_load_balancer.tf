resource "aws_lb" "ecs_service_lb" {
  #checkov:skip=CKV2_AWS_20:Ensure that ALB redirects HTTP requests into HTTPS ones
  enable_deletion_protection = true
  depends_on = [
    aws_s3_bucket.lb_log_bucket,
    aws_s3_bucket_policy.lb_log_bucket_policy
  ]
  idle_timeout               = 60
  drop_invalid_header_fields = true

  security_groups = var.expose_web == true ? [aws_security_group.lb_security_group_expose_web.id, aws_security_group.lb_security_group_uat_testers.id] : [aws_security_group.lb_security_group.id]

  count = var.expose_web == false ? length(var.services) : 0

  internal = true
  name     = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}"

  subnets = var.subnets

  access_logs {
    bucket  = aws_s3_bucket.lb_log_bucket.bucket
    prefix  = var.services[count.index]
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}" })
}

resource "aws_lb" "ecs_service_lb_expose_web" {
  enable_deletion_protection = true
  #checkov:skip=CKV2_AWS_20:Ensure that ALB redirects HTTP requests into HTTPS ones
  depends_on = [
    aws_s3_bucket.lb_log_bucket,
    aws_s3_bucket_policy.lb_log_bucket_policy
  ]

  idle_timeout               = 60
  drop_invalid_header_fields = true

  security_groups = var.expose_web == true ? [aws_security_group.lb_security_group_expose_web.id, aws_security_group.lb_security_group_uat_testers.id, aws_security_group.deloitte_vpn_allow_sg_80.id,aws_security_group.deloitte_vpn_allow_sg_443.id] : [aws_security_group.lb_security_group.id]

  count = var.expose_web == true ? length(var.services) : 0

  internal = var.services[count.index] == "web" ? false : true
  name     = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}"

  subnets = var.services[count.index] == "web" ? var.web_subnet : var.subnets

  access_logs {
    bucket  = aws_s3_bucket.lb_log_bucket.bucket
    prefix  = var.services[count.index]
    enabled = true
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}" })
}

resource "aws_lb_target_group" "ecs_service_target_group" {
  count = length(var.services)

  lifecycle {
    create_before_destroy = true
  }

  name_prefix = var.tags.project
  port        = var.ports[count.index]
  protocol    = var.health_check_protocol[count.index]
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled  = true
    interval = 120
    port     = var.ports[count.index]
    protocol = var.health_check_protocol[count.index]
    timeout  = 60
    path     = var.services[count.index] == "jbpm" ? "/" : "/ping"
  }

  tags = merge(var.tags, { Name = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-${var.services[count.index]}" })
}

resource "aws_alb_listener" "front_end" {
  #checkov:skip=CKV_AWS_103:Ensure that load balancer is using at least TLS 1.2
  #checkov:skip=CKV_AWS_2:Ensure ALB protocol is HTTPS
  count = var.expose_web == false ? length(var.services) : 0

  load_balancer_arn = aws_lb.ecs_service_lb[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "front_end_https" {
  count = var.expose_web == false ? length(var.services) : 0

  depends_on = [
    aws_acm_certificate.ecs_service_certificate
  ]

  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"

  load_balancer_arn = aws_lb.ecs_service_lb[count.index].arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.ecs_service_certificate[count.index].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_service_target_group[count.index].arn
  }
}

resource "aws_alb_listener" "front_end_web_exposed" {
  #checkov:skip=CKV_AWS_103:Ensure that load balancer is using at least TLS 1.2
  count = var.expose_web == true ? length(var.services) : 0

  load_balancer_arn = aws_lb.ecs_service_lb_expose_web[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "front_end_https_web_exposed" {
  count = var.expose_web == true ? length(var.services) : 0

  depends_on = [
    aws_acm_certificate.ecs_service_certificate
  ]

  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"

  load_balancer_arn = aws_lb.ecs_service_lb_expose_web[count.index].arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.ecs_service_certificate[count.index].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_service_target_group[count.index].arn
  }
}
