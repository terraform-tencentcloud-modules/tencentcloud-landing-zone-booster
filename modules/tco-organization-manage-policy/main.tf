locals {
  policy_ids = { for k, item in tencentcloud_organization_org_manage_policy.policies: k => item.policy_id }
}

resource "tencentcloud_organization_org_manage_policy" "policies" {
  for_each = { for item in var.org_manage_policies: item.name => item }

  name        = each.value.name
  content     = each.value.content
  type        = each.value.type
  description = each.value.description
}