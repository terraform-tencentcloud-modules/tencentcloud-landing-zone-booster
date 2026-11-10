# terraform-tencentcloud-billing-budget
Terraform module which creates a Billing Budget resource on TencentCloud.

> **Note:** This module wraps `tencentcloud_billing_budget`. Use `warn_jsons` for threshold reminders and optionally `dimensions_range` / `wave_threshold_jsons` to scope the budget and add volatility reminders.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_billing_budget.budget` | 1 | The billing budget with threshold / volatility reminders and optional dimension filtering. |

## Usage

```hcl
module "budget" {
  source = "../../../../tc-modules/modules/billing-budget"

  budget_name = "boost-life-monthly-budget"
  cycle_type  = "MONTH"   # DAY, MONTH, QUARTER, YEAR
  period_begin = "2025-01"
  period_end   = "2025-12"
  plan_type    = "FIX"    # FIX: fixed budget, CYCLE: planned budget
  budget_quota = "10000"
  bill_type    = "CONSUMPTION" # BILL: system bill, CONSUMPTION: consumption bill
  fee_type     = "REAL_COST"   # COST, REAL_COST, CASH, INCENTIVE, VOUCHER, TRANSFER, TAX, AMOUNT_BEFORE_TAX
  budget_note  = "Monthly cost budget for the landing zone"

  warn_jsons = [
    {
      warn_type       = "ACTUAL"        # ACTUAL: actual amount, FORECAST: forecast amount
      cal_type        = "PERCENTAGE"    # PERCENTAGE: percentage of budget, ABS: fixed value
      threshold_value = "80"
    }
  ]

  # Optional: dimension scoping (only one block is supported by the API)
  dimensions_range = {
    region_ids = [1, 4]   # ap-guangzhou, ap-shanghai, etc.
    business   = ["cvm"]
  }

  # Optional: volatility reminders
  wave_threshold_jsons = [
    {
      warn_type   = "ACTUAL"
      threshold   = "20"
      meta_type   = "chain"   # chain: month-on-month, yoy: year-on-year, fix: fixed value
      period_type = "month"   # day, month, weekday
    }
  ]
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
| `budget_name` | (Required) Budget name. | `string` | n/a |
| `cycle_type` | (Required) Cycle type, valid values: DAY, MONTH, QUARTER, YEAR. | `string` | n/a |
| `period_begin` | (Required) Valid period starting time 2025-01-01(cycle: days) / 2025-01 (cycle: months). | `string` | n/a |
| `period_end` | (Required) Expiration period end time 2025-12-01(cycle: days) / 2025-12 (cycle: months). | `string` | n/a |
| `plan_type` | (Required) FIX: fixed budget, CYCLE: planned budget. | `string` | n/a |
| `budget_quota` | (Required) Budget value limit. Fixed value when plan_type is FIX; JSON array `[{"dateDesc":"2025-07","quota":"1000"},...]` when CYCLE. | `string` | n/a |
| `bill_type` | (Required) BILL: system bill, CONSUMPTION: consumption bill. | `string` | n/a |
| `fee_type` | (Required) COST original price, REAL_COST actual cost, CASH cash, INCENTIVE gift, VOUCHER voucher, TRANSFER share, TAX tax, AMOUNT_BEFORE_TAX cash payment (before tax). | `string` | n/a |
| `budget_note` | (Optional) Budget remarks. | `string` | `""` |
| `warn_jsons` | (Required) Threshold reminder list. | `list(object({ warn_type = string, cal_type = string, threshold_value = string }))` | n/a |
| `dimensions_range` | (Optional) Budget dimension range conditions. Max 1 item. | `object` (see below) | `null` |
| `wave_threshold_jsons` | (Optional) Volatility reminder list. | `list(object({ warn_type = optional(string), threshold = optional(string), meta_type = optional(string), period_type = optional(string) }))` | `[]` |

### `dimensions_range` object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `business` | Products. | `list(string)` | `null` |
| `pay_mode` | Pay mode. | `list(string)` | `null` |
| `product_codes` | Sub-product. | `list(string)` | `null` |
| `component_codes` | Component codes. | `list(string)` | `null` |
| `zone_ids` | Zone ids. | `list(string)` | `null` |
| `region_ids` | Region ids. | `list(string)` | `null` |
| `project_ids` | Project ids. | `list(string)` | `null` |
| `action_types` | Action types. | `list(string)` | `null` |
| `consumption_types` | Consumption types. | `list(string)` | `null` |
| `payer_uins` | Payer uins. | `list(string)` | `null` |
| `owner_uins` | Owner uins. | `list(string)` | `null` |
| `tree_node_uniq_keys` | Unique key for end-level ledger unit. | `list(string)` | `null` |

## Outputs

This module currently does not declare any outputs (`outputs.tf` is empty).

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
