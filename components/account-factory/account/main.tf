# Get node information
data "tencentcloud_organization_nodes" "org_nodes" {
}

locals {
  root_node_id = [
    for item in data.tencentcloud_organization_nodes.org_nodes.items : item.node_id if item.parent_node_id == 0
  ][0]
}

# Create member account in resource directory
resource "tencentcloud_organization_org_member" "member" {
  # required
  name                 = var.member_name
  permission_ids       = var.permission_ids
  policy_type          = var.policy_type
  node_id              = (var.node_id != null && var.node_id != 0) ? var.node_id : local.root_node_id
  # optional
  pay_uin              = var.pay_uin
  force_delete_account = var.force_delete_account
  is_modify_nick_name  = var.is_modify_nick_name != null ? (var.is_modify_nick_name ? 1 : 0) : null
  record_id            = var.record_id
  remark               = var.remark
  tags                 = var.tags
}

resource "tencentcloud_organization_org_member_email" "org_member_emails" {
  count = var.enable_bound ? 1 : 0

  member_uin   = tencentcloud_organization_org_member.member.id
  email        = var.email
  phone        = var.phone
  country_code = var.country_code

  lifecycle {
    ignore_changes = [ email, phone ]
  }

  depends_on = [ tencentcloud_organization_org_member.member ]
}