output "listener_id" {
  description = "listener id"
  value       = tencentcloud_clb_listener.this.listener_id
}

output "listener_name" {
  description = "listener name"
  value       = var.listener_name
}

output "listener_port" {
  description = "listener port"
  value       = var.port
}

output "listener_protocol" {
  description = "listener protocol"
  value       = var.protocol
}

output "rule_id" {
  description = "rule ids"
  value = [
    for idx, rule in var.listener_rules :
    tencentcloud_clb_listener_rule.this[idx].rule_id
  ]
}