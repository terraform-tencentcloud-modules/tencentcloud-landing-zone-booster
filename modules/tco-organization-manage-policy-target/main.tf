resource "tencentcloud_organization_org_manage_policy_target" "policy_target" {
  count = length(var.org_manage_policy_targets)

  target_id   = var.org_manage_policy_targets[count.index].target_id
  target_type = var.org_manage_policy_targets[count.index].target_type
  policy_id   = var.org_manage_policy_targets[count.index].policy_id
  policy_type = var.org_manage_policy_targets[count.index].policy_type
}