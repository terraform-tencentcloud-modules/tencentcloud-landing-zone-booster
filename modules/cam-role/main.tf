data "tencentcloud_user_info" "info" {}

locals {
  uin = data.tencentcloud_user_info.info.owner_uin
}

resource "tencentcloud_cam_role" "cam_role" {
  name = var.name
  document = jsonencode({
    "version" = "2.0",
    "statement" = var.statement
  })
  description   = var.description
  session_duration = var.session_duration
  console_login = false
  tags = var.tag
}

resource "tencentcloud_cam_role_policy_attachment_by_name" "role_policy_attachment" {
  role_name   = var.role_name
  policy_name = var.policy_name
}