# read all pre policies
data "tencentcloud_cam_policies" "all" {}

locals {
  policy_map = { for policy in data.tencentcloud_cam_policies.all.policy_list : policy.name => policy.policy_id }

  user_policies = concat(
    [
      for policy_name in try(var.cam_policy.pre_policies, []) : {
        policy_name = policy_name
        policy_id   = lookup(local.policy_map, policy_name, 0)
      }
    ],
    [
      for policy in try(var.cam_policy.custom_policies, []) : {
        policy_name = policy.name
        policy_id   = tencentcloud_cam_policy.policies[policy.name].id
      }
    ],
  )
}

resource "random_password" "pwd" {
  length           = 12
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "tencentcloud_cam_access_key" "aksk" {
  count = var.use_api ? 1 : 0

  target_uin = tencentcloud_cam_user.user.uin
  status     = "Active" # activated (Active) or inactive (Inactive)

  depends_on = [ tencentcloud_cam_user.user ]
}

resource "tencentcloud_cam_user" "user" {
  name                = var.user_name
  phone_num           = var.user_phone_number
  country_code        = var.phone_country_code
  email               = var.user_email
  remark              = var.user_remark
  console_login       = var.console_login
  use_api             = var.use_api
  need_reset_password = var.need_reset_password
  password            = var.console_login ? (var.user_password != null ? var.user_password : random_password.pwd.result) : null
  force_delete        = var.force_delete
  tags                = var.tags
}

resource "tencentcloud_cam_policy" "policies" {
  for_each = { for policy in var.cam_policy.custom_policies : policy.name => policy }

  name        = each.value.name
  document    = each.value.document
  description = each.value.description
  tags        = each.value.tags
}

resource "tencentcloud_cam_user_policy_attachment" "user_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy}

  user_name = tencentcloud_cam_user.user.name
  policy_id = each.value.policy_id

  depends_on = [
    tencentcloud_cam_user.user,
    tencentcloud_cam_policy.policies
  ]
}