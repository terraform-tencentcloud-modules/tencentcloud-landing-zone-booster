resource "tencentcloud_billing_budget" "budget" {
  budget_name  = var.budget_name
  cycle_type   = var.cycle_type
  period_begin = var.period_begin
  period_end   = var.period_end
  plan_type    = var.plan_type
  budget_quota = var.budget_quota
  bill_type    = var.bill_type
  fee_type     = var.fee_type
  budget_note  = var.budget_note

  dynamic "warn_json" {
    for_each = var.warn_jsons
    content {
      warn_type       = warn_json.value.warn_type
      cal_type        = warn_json.value.cal_type
      threshold_value = warn_json.value.threshold_value
    }
  }

  dynamic "dimensions_range" {
    for_each = var.dimensions_range != null ? [var.dimensions_range] : []
    content {
      business            = dimensions_range.value.business
      pay_mode            = dimensions_range.value.pay_mode
      product_codes       = dimensions_range.value.product_codes
      component_codes     = dimensions_range.value.component_codes
      zone_ids            = dimensions_range.value.zone_ids
      region_ids          = dimensions_range.value.region_ids
      project_ids         = dimensions_range.value.project_ids
      action_types        = dimensions_range.value.action_types
      consumption_types   = dimensions_range.value.consumption_types
      payer_uins          = dimensions_range.value.payer_uins
      owner_uins          = dimensions_range.value.owner_uins
      tree_node_uniq_keys = dimensions_range.value.tree_node_uniq_keys
    }
  }


  dynamic "wave_threshold_json" {
    for_each = var.wave_threshold_jsons
    content {
      warn_type   = wave_threshold_json.value.warn_type
      threshold   = wave_threshold_json.value.threshold
      meta_type   = wave_threshold_json.value.meta_type
      period_type = wave_threshold_json.value.period_type
    }
  }
}