locals {
  product_id       = 1022425
  product_code     = "p_soccloud"
  sub_product_code = "sp_soccloud_cnsc"
}

resource "tencentcloud_billing_instance" "this" {
  # Required parameters
  product_code     = local.product_code
  sub_product_code = local.sub_product_code
  region_code      = var.region
  zone_code        = var.zone
  pay_mode         = var.pay_mode
  parameter        = jsonencode({
    pid                = local.product_id
    productCode        = local.product_code
    subProductCode     = local.sub_product_code
    timeSpan           = var.period
    timeUnit           = var.period_unit
    # Required parameters
    goodsNum           = var.parameter.goodsNum
    autoRenewFlag      = var.parameter.autoRenewFlag
    sv_soccloud_pc_ae  = var.parameter.sv_soccloud_pc_ae ? 1 : 0
    sv_soccloud_pc_ee  = var.parameter.sv_soccloud_pc_ee ? 1 : 0
    sv_soccloud_pc_fe  = var.parameter.sv_soccloud_pc_fe ? 1 : 0
    sv_soccloud_pc_la  = var.parameter.sv_soccloud_pc_la ? 1 : 0
    sv_soccloud_pc_ma  = var.parameter.sv_soccloud_pc_ma ? 1 : 0
    sv_soccloud_pc_mas = var.parameter.sv_soccloud_pc_mas ? 1 : 0
    sv_soccloud_pc_ss  = var.parameter.sv_soccloud_pc_ss ? 1 : 0
    tag                = var.parameter.tag
  })

  # Optional parameters
  project_id  = var.project_id
  period      = var.period
  period_unit = var.period_unit
  renew_flag  = var.renew_flag

  timeouts {
    create = var.create_timeout
  }
}