locals {
  users = { for k, v in var.users: k => v if var.create}
  user_ids = { for k, user in tencentcloud_identity_center_user.user: k => user.user_id}
}

resource "tencentcloud_identity_center_user" "user" {
  for_each  = local.users
  zone_id   = var.zone_id
  user_name    = each.value.user_name
  description  = try(each.value.description, "")
  display_name = try(each.value.display_name, each.value.user_name)
  email        = try(each.value.email, "")
  first_name   = try(each.value.first_name, "")
  last_name    = try(each.value.last_name, "")
  user_status  = try(each.value.user_status, "Enabled")
}
