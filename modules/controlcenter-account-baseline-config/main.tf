locals {
  role_list = data.tencentcloud_cam_roles.ccrole.role_list

  baseline_identifiers = [ for item in var.baseline_config_items : item.identifier ]
}

data "tencentcloud_cam_roles" "ccrole" {
  name = "ControlCenter_QCSLinkedRoleInAccountsEntMng"
}

resource "tencentcloud_cam_service_linked_role" "cc_role" {
  count = length(local.role_list) == 0 ? 1 : 0

  qcs_service_name = ["accountsentmng.controlcenter.cloud.tencent.com"]
  description      = "The current role is the ControlCenter service linked role, which will access your other service resources within the scope of the permissions of the associated policy."
  tags             = var.tags
}

resource "tencentcloud_controlcenter_account_factory_baseline_config" "this" {
  name = var.baseline_name
  
  dynamic "baseline_config_items" {
    for_each = var.baseline_config_items
    content {
      identifier    = baseline_config_items.value.identifier
      configuration = baseline_config_items.value.configuration
    }
  }

  depends_on = [
    tencentcloud_cam_service_linked_role.cc_role,
  ]
}