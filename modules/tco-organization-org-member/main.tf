locals {
  members     = { for idx, item in var.members: item.name => item}
  emails      = { for idx, item in var.members: item.name => item if item.enable_bound}
  # output
  member_uins = { for k, member in tencentcloud_organization_org_member.members: k => member.id}
}

resource "tencentcloud_organization_org_member" "members" {
  for_each = local.members

  # required
  name                 = each.value.name
  node_id              = each.value.node_id
  permission_ids       = each.value.permission_ids
  policy_type          = each.value.policy_type
  pay_uin              = each.value.pay_uin
  # optional
  force_delete_account = each.value.force_delete_account
  is_modify_nick_name  = each.value.is_modify_nick_name
  record_id            = each.value.record_id
  remark               = each.value.remark
  tags                 = each.value.tags
}

resource "tencentcloud_organization_org_member_email" "org_member_emails" {
  for_each = local.emails

  member_uin   = local.member_uins[each.key]
  email        = each.value.email
  phone        = each.value.phone
  country_code = each.value.country_code

  lifecycle {
    ignore_changes = [ email, phone ]
  }

  depends_on = [ tencentcloud_organization_org_member.members ]
}