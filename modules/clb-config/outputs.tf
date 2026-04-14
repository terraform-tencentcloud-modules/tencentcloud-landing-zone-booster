# Output the ID of the customized config
output "clb_config_id" {
  description = "The ID of the clb config"
  value       = tencentcloud_clb_customized_config.config.id
}