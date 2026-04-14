locals {
  groups = { for k, v in var.groups: k => v if var.create}
  group_ids = { for k, group in tencentcloud_identity_center_group.groups: k => group.group_id }
  user_attachment_list = flatten([
    for g_k, group in local.groups: [
      for user_id in try(group.users, []): {
        k = format("%s-%s", g_k, user_id)
        user_id  = user_id
        group_id = local.group_ids[g_k]
      }
    ]
  ])
  user_attachments = {
    for u in local.user_attachment_list: u.k => u
  }
}

resource "tencentcloud_identity_center_group" "groups" {
  for_each    = local.groups
  zone_id     = var.zone_id
  group_name  = each.value.group_name
  description = try(each.value.description, "")
}

resource "tencentcloud_identity_center_user_group_attachment" "user_group_attachment" {
  for_each = local.user_attachments
  zone_id  = var.zone_id
  user_id  = each.value.user_id
  group_id = each.value.group_id
}