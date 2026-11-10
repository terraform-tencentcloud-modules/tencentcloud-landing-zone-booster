################################################################################
### Private DNS Account Association Outputs
################################################################################
output "account_association_ids" {
  description = "Map of account association keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_account.accounts : k => v.id }
}

output "account_associations" {
  description = "Complete Private DNS account association resource objects"
  value       = tencentcloud_private_dns_account.accounts
}

output "account_association_details" {
  description = "Map of account association keys to their details (uin, email, nickname)"
  value = {
    for k, v in tencentcloud_private_dns_account.accounts : k => {
      account_uin = v.account_uin
      account     = v.account  # Email of the associated account
      nickname    = v.nickname # Nickname of the associated account
    }
  }
}
