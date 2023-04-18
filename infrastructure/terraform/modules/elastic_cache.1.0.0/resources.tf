resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  security_group_ids   = [aws_security_group.redis_security_group.id]
  engine_version       = "3.2.10"
  snapshot_retention_limit = 30
  subnet_group_name    = aws_elasticache_subnet_group.redis_cluster_subnet_group.name
  port                 = 6379
}

resource "aws_elasticache_subnet_group" "redis_cluster_subnet_group" {
  name       = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-redis-sg"
  subnet_ids = var.app_subnet_ids
}
