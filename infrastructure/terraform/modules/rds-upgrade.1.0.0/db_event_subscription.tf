# resource "aws_db_event_subscription" "rds_microservices_db_backup_event_subscription" {
#   name      = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-rds-core-db-export-event-subscription"
#   sns_topic = var.rds_snapshot_backup_sns_trigger

#   source_type = "db-instance"
#   source_ids  = [aws_db_instance.default.id]

#   event_categories = [
#     "maintenance",
#     "notification",
#   ]
# }
