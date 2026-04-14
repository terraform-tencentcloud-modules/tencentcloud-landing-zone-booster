# Tencent Cloud Billing Instance
# Used to manage Tencent Cloud billing instances (purchase, renewal, and cancellation of annual/monthly subscription products).

resource "tencentcloud_billing_instance" "this" {
  # Required parameters
  product_code     = var.product_code
  sub_product_code = var.sub_product_code
  region_code      = var.region_code
  zone_code        = var.zone_code
  pay_mode         = var.pay_mode
  parameter        = var.parameter

  # Optional parameters
  project_id  = var.project_id
  period      = var.period
  period_unit = var.period_unit
  renew_flag  = var.renew_flag

  timeouts {
    create = var.create_timeout
  }
}
