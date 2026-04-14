# read all pre policies
data "tencentcloud_cam_policies" "all" {}
# read current user info
data "tencentcloud_user_info" "info" {}
# Get members information
data "tencentcloud_organization_members" "members" {}
# Get user by name
data "tencentcloud_cam_users" "user" {
  count = var.principal.account_name != null && var.principal.account_name != "" ? 1 : 0

  name = var.principal.account_name
}

locals {
  policy_map = { for policy in data.tencentcloud_cam_policies.all.policy_list : policy.name => policy.policy_id }
  # members map
  org_members = {
    for m in data.tencentcloud_organization_members.members.items : m.name => m.member_uin
  }

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

  user_uin   = try(local.org_members[var.principal.account_name], null) != null ? local.org_members[var.principal.account_name] : try(data.tencentcloud_cam_users.user[0].user_list[0].uin, null)
  accunt_uin = local.user_uin == null ? data.tencentcloud_user_info.info.owner_uin : local.user_uin
  uin = (var.principal.account_uin != null && var.principal.account_uin != "") ? var.principal.account_uin : local.accunt_uin
}

resource "tencentcloud_cam_role" "role" {
  name             = var.role_name
  description      = var.description
  console_login    = var.console_login
  session_duration = var.session_duration
  document = jsonencode(
    {
      version = "2.0",
      statement = [
        {
          action = "name/sts:AssumeRole"
          effect = "allow"
          principal = {
            var.principal.type == 1 ? "qcs" : "service" = [
              var.principal.type == 1 ? "qcs::cam::uin/${local.uin}:root" : var.principal.service_name
            ]
          }
        },
      ]
    }
  )
  tags = var.tags
}

resource "tencentcloud_cam_policy" "policies" {
  for_each = { for policy in var.cam_policy.custom_policies : policy.name => policy }

  name        = each.value.name
  document    = each.value.document
  description = each.value.description
  tags        = each.value.tags
}

resource "tencentcloud_cam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy}
  
  role_id   = tencentcloud_cam_role.role.id
  policy_id = each.value.policy_id

  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cam_policy.policies
  ]
}