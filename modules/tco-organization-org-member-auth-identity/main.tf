resource "tencentcloud_organization_org_member_auth_identity_attachment" "this" {
  for_each = { for item in var.member_identity_ids: item.member_uin => item}
  
  member_uin   = each.value.member_uin
  identity_ids = each.value.identity_ids
}