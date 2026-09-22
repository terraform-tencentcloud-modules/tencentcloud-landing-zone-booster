################################################################################
### Private DNS Account Association
################################################################################
# Associates accounts with Private DNS, enabling cross-account VPC binding for private zones.
# Once an account is associated, it can be used to bind VPCs from that account to private DNS zones.
resource "tencentcloud_private_dns_account" "accounts" {
  for_each = var.account_associations

  account_uin = each.value.account_uin
}