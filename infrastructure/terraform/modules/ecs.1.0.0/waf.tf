resource "random_string" "random_suffix_waf" {
  length  = 6
  special = false
}

resource "aws_wafv2_web_acl" "ecs_service_lb_waf_sec" {
  name  = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-waf-metrics-rule-2"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-waf-metrics-rule-2"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "rule-1"
    priority = 2
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }
        excluded_rule {
          name = "NoUserAgent_HEADER"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-waf-metrics-rule-1"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-ecs-services-waf-metrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "ecs_service_lb_waf_association" {
  count = var.expose_web == false ? length(var.services) : 0

  resource_arn = aws_lb.ecs_service_lb[count.index].arn
  web_acl_arn  = aws_wafv2_web_acl.ecs_service_lb_waf_sec.arn
}

resource "aws_wafv2_web_acl_association" "ecs_service_lb_waf_association_expose_web" {
   count = var.expose_web == true ? length(var.services) : 0

  resource_arn = aws_lb.ecs_service_lb_expose_web[count.index].arn
  web_acl_arn  = aws_wafv2_web_acl.ecs_service_lb_waf_sec.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "ecs_service_lb" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.ecs_service_lb_waf_sec.arn
  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }
}

resource "aws_cloudwatch_log_group" "waf_logs_log_group" {
  name              = "aws-waf-logs-${var.tags.agency}-${var.tags.project}-${var.tags.environment}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.waf_logs_key.arn
}

resource "aws_kms_key" "waf_logs_key" {
  description         = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-waf-logs-${random_string.random_suffix.result}"
  enable_key_rotation = true
  tags                = merge(var.tags)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "dms service"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "cloudwatch service"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
      },
      {
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Sid      = "Root Account"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}

resource "aws_wafv2_ip_set" "deloite_vpn_address_range" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-waf-ip-allow-list"
  description        = "Deloitte VPN Address Range"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["10.159.162.0/24", "10.159.161.0/24","24.206.105.28/32", "24.206.105.29/32", "24.206.66.40/32", "24.206.66.41/32", "24.206.68.40/32", "24.206.68.41/32", "24.206.70.40/32", "24.206.70.41/32", "24.206.71.40/32", "24.206.71.41/32", "24.206.72.40/32", "24.206.72.41/32", "24.206.73.50/32", "24.206.73.51/32", "24.206.76.48/32", "24.206.76.49/32", "24.206.77.40/32", "24.206.77.41/32", "24.206.78.44/32", "24.206.78.45/32", "24.206.80.48/32", "24.206.80.49/32", "24.206.82.51/32", "24.206.82.52/32", "24.206.84.58/32", "24.206.84.59/32", "24.239.131.30/32", "24.239.131.31/32", "24.239.134.30/32", "24.239.134.31/32", "24.239.140.30/32", "24.239.140.31/32", "167.219.88.140/32", "167.219.0.140/32"]
}