resource "aws_elasticache_subnet_group" "default" {
  count      = "${var.enabled == "true" ? 1 : 0}"
  name       = "${format("%s-%s-sg", var.name, var.stage)}"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_elasticache_replication_group" "default" {
  engine                        = "redis"
  engine_version                = "${var.engine_version}"
  count                         = "${var.enabled == "true" ? 1 : 0}"
  replication_group_id          = "${format("%s-%s", var.name, var.stage)}"
  replication_group_description = "${format("%s-%s Redis cluster", var.name, var.stage)}"
  node_type                     = "${var.instance_type}"
  number_cache_clusters         = "${var.cluster_size}"
  port                          = "${var.port}"
  availability_zones            = ["${slice(var.availability_zones, 0, var.cluster_size)}"]
  automatic_failover_enabled    = "${var.automatic_failover}"
  subnet_group_name             = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids            = ["${var.security_groups}"]
  maintenance_window            = "${var.maintenance_window}"
  notification_topic_arn        = "${var.notification_topic_arn}"
  snapshot_retention_limit      = "${var.snapshot_retention_limit}"
  snapshot_window               = "${var.snapshot_window}"

  tags = "${var.tags}"
}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = "${var.enabled == "true" ? 1 : 0}"
  alarm_name          = "${format("%s-%s", var.name, var.stage)}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "${var.alarm_cpu_threshold_percent}"

  dimensions {
    CacheClusterId = "${format("%s-%s", var.name, var.stage)}"
  }

  alarm_actions = ["${var.alarm_actions}"]
  depends_on    = ["aws_elasticache_replication_group.default"]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = "${var.enabled == "true" ? 1 : 0}"
  alarm_name          = "${format("%s-%s", var.name, var.stage)}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "${var.alarm_memory_threshold_bytes}"

  dimensions {
    CacheClusterId = "${format("%s-%s", var.name, var.stage)}"
  }

  alarm_actions = ["${var.alarm_actions}"]
  depends_on    = ["aws_elasticache_replication_group.default"]
}
