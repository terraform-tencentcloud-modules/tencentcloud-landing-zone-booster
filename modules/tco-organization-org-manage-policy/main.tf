locals {
  policy_name = var.policy_name
  policy_id = var.create ? concat(tencentcloud_organization_org_manage_policy.org_manage_policy.*.policy_id, [""])[0] : ""
}

resource "tencentcloud_organization_org_manage_policy" "org_manage_policy" {
  count = var.create ? 1 : 0
  name        = local.policy_name # "FullAccessPolicy"
  content     = var.content # "{\"version\":\"2.0\",\"statement\":[{\"effect\":\"allow\",\"action\":\"*\",\"resource\":\"*\"}]}"
  type        = var.type # "SERVICE_CONTROL_POLICY"
  description = var.description # "Full access policy"
}

resource "tencentcloud_organization_org_manage_policy_target" "node" {
  for_each = var.create ? var.target_nodes : {}
  target_id   = each.value.node_id
  target_type = "NODE"
  policy_id   = local.policy_id
  policy_type = var.type
}

resource "tencentcloud_organization_org_manage_policy_target" "member" {
  for_each = var.create ? var.target_users : {}
  target_id   = each.value.user_id
  target_type = "MEMBER"
  policy_id   = local.policy_id
  policy_type = var.type
}