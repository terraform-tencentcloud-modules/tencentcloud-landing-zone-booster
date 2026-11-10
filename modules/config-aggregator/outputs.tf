output "id" {
  description = "Resource id (account_group_id#owner_uin)."
  value       = tencentcloud_config_aggregator.this.id
}

output "account_group_id" {
  description = "Account group id (aggregator ID)."
  value       = tencentcloud_config_aggregator.this.account_group_id
}

output "aggregator_status" {
  description = "Creation status of the aggregator."
  value       = tencentcloud_config_aggregator.this.aggregator_status
}

output "aggregator_accounts" {
  description = "Resolved member accounts (filled automatically for RD aggregators by the cloud)."
  value       = tencentcloud_config_aggregator.this.aggregator_accounts
}
