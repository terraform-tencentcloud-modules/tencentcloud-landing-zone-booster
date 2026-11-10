locals {
  product_id       = 1021314
  product_code     = "p_kms"
  sub_product_code = "sp_kms_pg"
}

resource "tencentcloud_billing_instance" "this" {
  # Required parameters
  product_code     = local.product_code
  sub_product_code = local.sub_product_code
  region_code      = var.region
  zone_code        = var.zone
  pay_mode         = var.pay_mode
  parameter        = jsonencode({
    # common
    pid                = local.product_id
    productCode        = local.product_code
    subProductCode     = local.sub_product_code
    goodsNum           = var.parameter.goodsNum
    autoRenewFlag      = var.parameter.autoRenewFlag
    timeSpan           = var.period
    timeUnit           = var.period_unit
    # kms config
    sv_kms_pg_pro       = var.parameter.sv_kms_pg_pro ? 1 : 0
    sv_kms_exp_data_key = var.parameter.sv_kms_exp_data_key
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