resource "tencentcloud_batch_apply_account_baselines" "baselines" {  
  member_uin_list = var.member_uin_list

  dynamic "baseline_config_items" {
    for_each = var.baseline_config_items
    content {
      identifier    = baseline_config_items.value.identifier
      configuration = baseline_config_items.value.configuration
    }
  }
}