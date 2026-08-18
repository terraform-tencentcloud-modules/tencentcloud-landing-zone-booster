# Get members information
data "tencentcloud_organization_members" "members" {}

locals {
  org_members = {
    for m in data.tencentcloud_organization_members.members.items : m.name => m.member_uin
  }

  identity_member_ids = flatten([
    for item in var.assume_role_policies : [
      for member in item.members : {
        key          = "${item.assume_role_name}-${member.member_uin != null ? member.member_uin : local.org_members[member.member_name]}"
        member_uin   = member.member_uin != null ? member.member_uin : local.org_members[member.member_name],
        identity_ids = [
          tencentcloud_organization_org_identity.this[item.assume_role_name].id
        ]
      }
    ]
  ])

  identity_ids = {
    for item in var.assume_role_policies : item.assume_role_name => tencentcloud_organization_org_identity.this[item.assume_role_name].id
  }
}

resource "tencentcloud_organization_org_identity" "this" {
  for_each = { for item in var.assume_role_policies : item.assume_role_name => item}

  identity_alias_name = each.value.assume_role_name
  description         = each.value.description

  dynamic "identity_policy" {
    for_each = each.value.policies
    content {
      policy_id       = identity_policy.value.policy_id
      policy_name     = identity_policy.value.policy_name
      policy_type     = identity_policy.value.policy_type
      policy_document = identity_policy.value.policy_document
    }
  }
}

resource "tencentcloud_organization_org_member_auth_identity_attachment" "this" {
  for_each = { for item in local.identity_member_ids: item.key => item}
  
  member_uin   = each.value.member_uin
  identity_ids = each.value.identity_ids

  depends_on = [ tencentcloud_organization_org_identity.this ]
}