resource "aws_msk_cluster" "cdle_kafka" {
  #checkov:skip=CKV_AWS_81:Ensure MSK Cluster encryption in rest and transit is enabled
  lifecycle {
    ignore_changes = [
      client_authentication,
    ]
  }

  depends_on = [
    aws_security_group.kafka_security_group
  ]

  cluster_name           = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-kafkacluster"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = length(var.subnets) * var.replica_multiplier

  client_authentication {
    unauthenticated = true
  }

  broker_node_group_info {
    instance_type  = var.instance_type
    client_subnets = var.subnets

    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
    security_groups = [aws_security_group.kafka_security_group.id]
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka_broker_logs.name
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = true
    }
    encryption_at_rest_kms_key_arn = var.kms_msk_arn
  }
}

resource "random_password" "msk_root_password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

  resource "aws_cloudwatch_log_group" "kafka_broker_logs" {
    name              = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-kafka-broker-logs"
    retention_in_days = 365
    kms_key_id = aws_kms_key.kafka_broker_logs.arn
  }

