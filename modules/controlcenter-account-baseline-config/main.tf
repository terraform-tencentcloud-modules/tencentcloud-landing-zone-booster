locals {
  baseline_identifiers = [ for item in var.baseline_config_items : item.identifier ]
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

  depends_on = [ tencentcloud_cam_service_linked_role.cc_role ]
}