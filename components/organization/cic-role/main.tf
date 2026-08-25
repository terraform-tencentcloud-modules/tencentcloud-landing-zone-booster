################################################################################
### Data source to get all preset CAM policies
################################################################################
data "tencentcloud_cam_policies" "preset" {
  type = 2 # 2 = preset policies
}

################################################################################
### Data source to get all organization members
################################################################################
data "tencentcloud_organization_members" "members" {}

locals {
  # Map of policy_name => policy_id for all preset policies (reverse lookup)
  preset_policies_by_name = {
    for policy in data.tencentcloud_cam_policies.preset.policy_list :
    policy.name => policy.policy_id
  }

  # Map of member_name => member_uin for all organization members
  org_members_map = {
    for member in data.tencentcloud_organization_members.members.items :
    member.name => member.member_uin
  }
}

################################################################################
### Role Configuration 
################################################################################
resource "tencentcloud_identity_center_role_configuration" "roles" {
  for_each = { for item in var.role_config : item.role_name => item }

  zone_id                 = var.zone_id
  role_configuration_name = each.value.role_name
  description             = each.value.description
  session_duration        = var.session_duration
  relay_state             = each.value.relay_state
}

################################################################################
### Attach preset policies to roles
################################################################################
resource "tencentcloud_identity_center_role_configuration_permission_policy_attachment" "attachment" {
  for_each = {
    for item in flatten([
      for role in var.role_config : [
        for policy_name in coalesce(role.preset_policy_names, []) : {
          key         = "${role.role_name}-${policy_name}"
          role_name   = role.role_name
          policy_id   = local.preset_policies_by_name[policy_name]
          policy_name = policy_name
        }
      ]
    ]) : item.key => item
  }

  zone_id               = var.zone_id
  role_configuration_id = tencentcloud_identity_center_role_configuration.roles[each.value.role_name].role_configuration_id
  role_policy_id        = each.value.policy_id
  role_policy_name      = each.value.policy_name
}

################################################################################
### Attach custom policies to roles
################################################################################
resource "tencentcloud_identity_center_role_configuration_permission_custom_policy_attachment" "custom_policies" {
  for_each = {
    for item in flatten([
      for role in var.role_config : [
        for policy in coalesce(role.custom_policies, []) : {
          key             = "${role.role_name}-${policy.name}"
          role_name       = role.role_name
          policy_name     = policy.name
          policy_document = policy.policy_document
        }
      ]
    ]) : item.key => item
  }
  zone_id               = var.zone_id
  role_configuration_id = tencentcloud_identity_center_role_configuration.roles[each.value.role_name].role_configuration_id
  role_policy_name      = each.value.policy_name
  role_policy_document  = each.value.policy_document
}

################################################################################
### Sync role assignments to the member account
################################################################################
resource "tencentcloud_identity_center_role_assignment" "role_assignment" {
  for_each = {
    for item in var.role_assignments :
    "${item.role_name}-${item.principal_id}-${coalesce(item.target_uin, local.org_members_map[item.target_name])}" => item
  }

  zone_id               = var.zone_id
  principal_id          = each.value.principal_id
  principal_type        = each.value.principal_type
  target_uin            = coalesce(each.value.target_uin, local.org_members_map[each.value.target_name])
  target_type           = each.value.target_type
  role_configuration_id = tencentcloud_identity_center_role_configuration.roles[each.value.role_name].role_configuration_id
  deprovision_strategy  = each.value.deprovision_strategy
}
