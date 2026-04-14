resource "tencentcloud_invite_organization_member_operation" "member_operation" {
  count          = var.create ? 1 : 0
  member_uin     = var.member_uin
  name           = var.name
  policy_type    = var.policy_type # "Financial"
  node_id        = var.node_id
  is_allow_quit  = var.is_allow_quit
  permission_ids = var.permission_ids # [ number ]
  remark         = var.remark
  pay_uin        = var.pay_uin

  dynamic "tags" {
    for_each = var.tags
    content {
      tag_key = tags.key
      tag_value = tags.value
    }
  }
}