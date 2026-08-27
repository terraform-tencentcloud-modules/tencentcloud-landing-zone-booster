# read all pre policies
data "tencentcloud_cam_policies" "all" {}

locals {
  policy_map = { for policy in data.tencentcloud_cam_policies.all.policy_list : policy.name => policy.policy_id }

  user_policies = concat(
    [
      for policy_name in try(var.cam_policy.preset_policies, []) : {
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
              var.principal.type == 1 ? "qcs::cam::uin/${var.principal.account_uin}:root" : var.principal.service_name
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