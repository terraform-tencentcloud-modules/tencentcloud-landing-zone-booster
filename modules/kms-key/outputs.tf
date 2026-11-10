output "key_id" {
  description = "The ID of the KMS key"
  value       = try(tencentcloud_kms_key.tc_kms_key[0].id, "")
}

output "key_state" {
  description = "The state of the KMS key"
  value       = try(tencentcloud_kms_key.tc_kms_key[0].key_state, "")
}
