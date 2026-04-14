locals {
  product_id       = 1002147
  product_code     = "p_cloudfirewall"
  sub_product_code = "sp_cloudfirewall_svv1"
}

resource "tencentcloud_billing_instance" "this" {
  # Required parameters
  product_code     = local.product_code
  sub_product_code = local.sub_product_code
  region_code      = var.region
  zone_code        = var.zone
  pay_mode         = var.pay_mode
  parameter        = jsonencode({
    # Common
    pid                = local.product_id
    productCode        = local.product_code
    subProductCode     = local.sub_product_code
    timeSpan           = var.period
    timeUnit           = var.period_unit
    goodsNum           = var.parameter.goodsNum

    # Version
    sv_cloudfirewall_basic_aeps = var.parameter.sv_cloudfirewall_basic_aeps ? 1 : 0
    sv_cloudfirewall_basic_eeps = var.parameter.sv_cloudfirewall_basic_eeps ? 1 : 0
    sv_cloudfirewall_basic_ueps = var.parameter.sv_cloudfirewall_basic_ueps ? 1 : 0

    # Log analysis and Log storage
    sv_cloudfirewall_extended_clasps  = var.parameter.sv_cloudfirewall_extended_clasps ? 1 : 0
    sv_cloudfirewall_extended_clsesps = var.parameter.sv_cloudfirewall_extended_clsesps

    # Extended configuration
    sv_cloudfirewall_extended_ibtesps = var.parameter.sv_cloudfirewall_extended_ibtesps
    sv_cloudfirewall_extended_vpcbges = var.parameter.sv_cloudfirewall_extended_vpcbges
    sv_cloudfirewall_extended_vpc     = var.parameter.sv_cloudfirewall_extended_vpc
    sv_cloudfirewall_extended_ndr     = var.parameter.sv_cloudfirewall_extended_ndr
    sv_cloudfirewall_extended_pcs     = var.parameter.sv_cloudfirewall_extended_pcs
    sv_cloudfirewall_extended_sub     = var.parameter.sv_cloudfirewall_extended_sub
    sv_cloudfirewall_extended_subs    = var.parameter.sv_cloudfirewall_extended_subs
    sv_cloudfirewall_extended_ates    = var.parameter.sv_cloudfirewall_extended_ates
    sv_cloudfirewall_extended_spt     = var.parameter.sv_cloudfirewall_extended_spt ? 1 : 0
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