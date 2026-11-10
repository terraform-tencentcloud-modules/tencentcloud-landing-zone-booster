# Get node information
data "tencentcloud_organization_nodes" "node" {}

# Get members information
data "tencentcloud_organization_members" "members" {}

locals {
  policy_type = "TAG_POLICY"

  node_ids = {
    for item in data.tencentcloud_organization_nodes.node.items : item.name => item.node_id
  }

  org_members = {
    for item in data.tencentcloud_organization_members.members.items : item.name => item.member_uin
  }

  org_manage_policies = [
    for item in var.org_tag_policies : {
      name        = item.name
      content     = file(item.path)
      type        = local.policy_type
      description = item.description
    }
  ]

  policy_target_node = flatten([
    for item in var.org_tag_policies : [
      for target in item.targets : {
        policy_name = item.name
        target_id   = target.target_id != null ? target.target_id : local.node_ids[target.target_name]
        target_type = "NODE"
      } if target.target_type == "NODE"
    ]
  ])

  policy_target_member = flatten([
    for item in var.org_tag_policies : [
      for target in item.targets : {
        policy_name = item.name
        target_id   = target.target_id != null ? target.target_id : local.org_members[target.target_name]
        target_type = "MEMBER"
      } if target.target_type != "NODE"
    ]
  ])

  tag_policy_targets = concat(local.policy_target_node, local.policy_target_member)

  org_manage_policy_targets = [
    for item in local.tag_policy_targets : {
      policy_id   = tencentcloud_organization_org_manage_policy.policies[item.policy_name].policy_id
      policy_type = local.policy_type
      target_id   = item.target_id
      target_type = item.target_type
    }
  ]
}

# enable tag policy
resource "tencentcloud_organization_org_manage_policy_config" "policy_config" {
  organization_id = var.organization_id
  policy_type     = local.policy_type
}

# create tag policy
resource "tencentcloud_organization_org_manage_policy" "policies" {
  for_each = { for item in local.org_manage_policies: item.name => item }

  name        = each.value.name
  content     = each.value.content
  type        = each.value.type
  description = each.value.description

  depends_on = [ tencentcloud_organization_org_manage_policy_config.policy_config ]
}

# bind tag policy target
resource "tencentcloud_organization_org_manage_policy_target" "policy_target" {
  count = length(local.org_manage_policy_targets)

  target_id   = local.org_manage_policy_targets[count.index].target_id
  target_type = local.org_manage_policy_targets[count.index].target_type
  policy_id   = local.org_manage_policy_targets[count.index].policy_id
  policy_type = local.org_manage_policy_targets[count.index].policy_type

  depends_on = [ tencentcloud_organization_org_manage_policy.policies ]
}