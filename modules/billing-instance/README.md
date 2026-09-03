# terraform-tencentcloud-billing-instance
Terraform module which creates a Billing Instance resource on TencentCloud.

> **Note:** This module wraps `tencentcloud_billing_instance`, used to manage annual/monthly subscription products (purchase, renewal, and cancellation) via the billing system. `pay_mode` currently only supports `PrePay`.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_billing_instance.this` | 1 | The billing (subscription) instance. |

## Usage

```hcl
module "billing_instance" {
  source = "../../../../tc-modules/modules/billing-instance"

  product_code     = "p_cvm"        # Product code
  sub_product_code = "sp_cvm_s5"    # Sub-product code
  region_code      = "ap-guangzhou" # Region code, e.g. ap-guangzhou
  zone_code        = "ap-guangzhou-3" # Availability zone code, e.g. ap-guangzhou-3
  pay_mode         = "PrePay"       # Currently only PrePay supported
  parameter        = jsonencode({   # Product detail JSON string
    cpu             = 2
    memory          = 4
    instanceChargeType = "PREPAID"
  })

  project_id  = 0                                          # Project ID
  period      = 1                                          # Purchase duration, max 36
  period_unit = "m"                                        # m (month), y (year)
  renew_flag  = "NOTIFY_AND_MANUAL_RENEW"                  # Renewal flag
  create_timeout = "20m"                                   # Create timeout
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.1.0 |
| tencentcloud | >= 1.82.61 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `product_code` | (Required) Product code. | `string` | n/a |
| `sub_product_code` | (Required) Sub-product code. | `string` | n/a |
| `region_code` | (Required) Region code, e.g. `ap-guangzhou`. | `string` | n/a |
| `zone_code` | (Required) Availability zone code, e.g. `ap-guangzhou-3`. | `string` | n/a |
| `pay_mode` | (Required) Pay mode, currently only supports `PrePay` (prepaid / annual-monthly subscription). | `string` | `"PrePay"` |
| `parameter` | (Required) JSON string of product detail information. | `string` | n/a |
| `project_id` | (Optional) Project ID. | `number` | `0` |
| `period` | (Optional) Purchase duration, max 36. | `number` | `1` |
| `period_unit` | (Optional) Purchase duration unit: `m` (month), `y` (year). | `string` | `"m"` |
| `renew_flag` | (Optional) Auto-renew flag: `NOTIFY_AND_MANUAL_RENEW` (manual renew), `NOTIFY_AND_AUTO_RENEW` (auto renew), `DISABLE_NOTIFY_AND_MANUAL_RENEW` (disable renew). | `string` | `"NOTIFY_AND_MANUAL_RENEW"` |
| `create_timeout` | (Optional) Create timeout. | `string` | `"20m"` |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | The billing instance ID. |
| `billing_instance` | The full billing instance information. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
