resource "tencentcloud_organization_org_manage_policy_config" "policy_config" {
  organization_id = var.organization_id
  policy_type     = var.policy_type
}