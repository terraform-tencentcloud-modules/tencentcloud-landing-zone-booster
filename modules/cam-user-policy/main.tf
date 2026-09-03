# read all pre policies
data "tencentcloud_cam_policies" "all" {
}

locals {
  policy_map = { for policy in data.tencentcloud_cam_policies.all.policy_list : policy.name => policy.policy_id }

  user_policies = concat(
    flatten([
      for user_key, user in var.users : [
        for policy_name in try(user.pre_policy_names, []) : {
          k         = format("%s.%s", user_key, policy_name)
          user_key  = user_key
          policy_id = lookup(local.policy_map, policy_name, 0)
        }
      ]
    ]),
    flatten([
      for user_key, user in var.users : [
        for policy_name in try(user.custom_policy_names, []) : {
          k         = format("%s.%s", user_key, policy_name)
          user_key  = user_key
          policy_id = tencentcloud_cam_policy.policies[policy_name].id
        }
      ]
    ]),
  )
  user_policy_map = { for user_policy in local.user_policies : user_policy.k => user_policy }

  create_access_keys = {
    for user_key, user in var.users : user_key => {
      target_uin = tencentcloud_cam_user.users[user_key].uin
      status     = try(user.access_key_status, "Active") // activated (Active) or inactive (Inactive)
    } if try(user.create_access_key, false)
  }
}

resource "random_password" "pwds" {
  for_each = var.users

  length           = 12
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# create user
resource "tencentcloud_cam_user" "users" {
  for_each = var.users

  name                = each.key // ForceNew, so there is no need a name variable in values
  remark              = try(each.value.user_remark, each.key)
  console_login       = try(each.value.console_login, true)
  use_api             = try(each.value.use_api, true)
  need_reset_password = try(each.value.need_reset_password, true)
  password            = try(each.value.console_login, true) ? (try(each.value.password, null) != null ? each.value.password : random_password.pwds[each.key].result) : null
  phone_num           = try(each.value.phone_num, "")
  email               = try(each.value.email, "")
  country_code        = try(each.value.country_code, "86")
  force_delete        = try(each.value.force_delete, true)
  tags                = try(each.value.user_tags, {})
}

# create policies
resource "tencentcloud_cam_policy" "policies" {
  for_each = var.policies

  name        = each.key // ForceNew
  document    = try(each.value.document, null)
  description = try(each.value.description, "")
}

# attach policies
resource "tencentcloud_cam_user_policy_attachment" "user_policy_attachment_basic" {
  for_each = local.user_policy_map

  user_name = tencentcloud_cam_user.users[each.value.user_key].name
  policy_id = each.value.policy_id
}

# access key
resource "tencentcloud_cam_access_key" "access_keys" {
  for_each = local.create_access_keys
  
  target_uin = each.value.target_uin
  status     = each.value.status
}