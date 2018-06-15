output "id" {
  value = "${join("", aws_elasticache_replication_group.default.*.id)}"
}

output "security_group_id" {
  value = "${join(",", flatten(aws_elasticache_replication_group.default.*.security_group_ids))}"
}

output "primary_endpoint_address" {
  value = ["${join(",", flatten(aws_elasticache_replication_group.default.*.primary_endpoint_address))}"]
}

output "port" {
  value = "${var.port}"
}
