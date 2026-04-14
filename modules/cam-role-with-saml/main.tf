resource "tencentcloud_cam_saml_provider" "saml_provider_basic" {
  count = var.create_saml ? 1 : 0

  name        = var.saml_name
  meta_data   = var.meta_data
  description = var.saml_description
}

resource "tencentcloud_cam_role" "role" {
  count = var.create_role ? 1 : 0

  document      = var.role_document
  name          = var.role_name
  console_login = var.console_login
  description   = var.role_description
  tags          = var.role_tags
}

resource "tencentcloud_cam_policy" "policy" {
  count = var.create_policy ? 1 : 0

  name        = var.policy_name
  document    = var.policy_document
  description = var.policy_description
}

resource "tencentcloud_cam_role_policy_attachment" "role_policy_attach" {
  role_id   = tencentcloud_cam_role.role[0].id
  policy_id = length(var.policy_id) == 0 ? tencentcloud_cam_policy.policy[0].id : var.policy_id
}