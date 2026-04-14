resource "tencentcloud_organization_org_identity" "this" {
  identity_alias_name = var.identity_alias_name
  description         = var.description

  dynamic "identity_policy" {
    for_each = var.identity_policies
    content {
      policy_id       = identity_policy.value.policy_id
      policy_name     = identity_policy.value.policy_name
      policy_type     = identity_policy.value.policy_type
      policy_document = try(identity_policy.value.policy_document, null)
    }
  }
}