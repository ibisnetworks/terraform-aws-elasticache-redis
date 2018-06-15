variable "namespace" {
  default = "global"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "redis"
}

variable "security_groups" {
  type = "list"
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  type    = "list"
  default = []
}

variable "maintenance_window" {
  default = "wed:03:00-wed:04:00"
}

variable "cluster_size" {
  default = "1"
}

variable "port" {
  default = "6379"
}

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "family" {
  default = "redis3.2"
}

variable "engine_version" {
  default = "3.2.4"
}

variable "notification_topic_arn" {
  default = ""
}

variable "alarm_cpu_threshold_percent" {
  default = "75"
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  default = "10000000"
}

variable "alarm_actions" {
  type    = "list"
  default = []
}

variable "apply_immediately" {
  default = "true"
}

variable "automatic_failover" {
  default = "false"
}

variable "availability_zones" {
  type = "list"
}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "snapshot_window" {
  type        = "string"
  description = "Window in UTC during which Elasticache will make snapshots, given a non-zero retention period"
  default     = "05:00-07:00"
}

variable "snapshot_retention_limit" {
  type        = "string"
  description = "Number of days to retain Redis snapshots (defaults to zero, disabling backup)"
  default     = "0"
}
