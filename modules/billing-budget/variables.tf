# 预算相关变量
variable "budget_name" {
  description = "(Required) Budget name."
  type        = string
}

variable "cycle_type" {
  description = "(Required) Cycle type, valid values: DAY, MONTH, QUARTER, YEAR."
  type        = string
}

variable "period_begin" {
  description = "(Required) Valid period starting time 2025-01-01(cycle: days) / 2025-01 (cycle: months)."
  type        = string
}

variable "period_end" {
  description = "(Required) Expiration period end time 2025-12-01(cycle: days) / 2025-12 (cycle: months)."
  type        = string
}

variable "plan_type" {
  description = "(Required) FIX: fixed budget, CYCLE: planned budget."
  type        = string
}

variable "budget_quota" {
  description = "(Required) Budget value limit. Transfer fixed value when the budget plan type is FIX(Fixed Budget); Passed when the budget plan type is CYCLE(Planned Budget)[{\"dateDesc\":\"2025-07\",\"quota\":\"1000\"},{\"dateDesc\":\"2025-08\",\"quota\":\"2000\"}]."
  type        = string
}

variable "bill_type" {
  description = "(Required) BILL: system bill, CONSUMPTION: consumption bill."
  type        = string
}

variable "fee_type" {
  description = "(Required) COST original price, REAL_COST actual cost, CASH cash, INCENTIVE gift, VOUCHER voucher, TRANSFER share, TAX tax, AMOUNT_BEFORE_TAX cash payment (before tax)."
  type        = string
}

variable "budget_note" {
  description = "(Optional) Budget remarks."
  type        = string
  default     = ""
}

# 告警配置变量
variable "warn_jsons" {
  description = "(Required) Threshold reminder."
  type = list(object({
    warn_type       = string  # ACTUAL: actual amount, FORECAST: forecast amount.
    cal_type        = string  # PERCENTAGE: Percentage of budget amount, ABS: fixed value.
    threshold_value = string  # Threshold (greater than or equal to 0).
  }))
}

variable "dimensions_range" {
  description = "(Optional) Budget dimension range conditions. Max 1 Items to be set"
  type = object({
    business            = optional(list(string)) # Products
    pay_mode            = optional(list(string)) # Pay mode
    product_codes       = optional(list(string)) # Sub-product
    component_codes     = optional(list(string)) # Component codes
    zone_ids            = optional(list(string)) # Zone ids
    region_ids          = optional(list(string)) # Region ids
    project_ids         = optional(list(string)) # Project ids
    action_types        = optional(list(string)) # Action types
    consumption_types   = optional(list(string)) # Consumption types
    payer_uins          = optional(list(string)) # Payer uins
    owner_uins          = optional(list(string)) # Owner uins
    tree_node_uniq_keys = optional(list(string)) # Unique key for end-level ledger unit
    tags                = optional(list(object({
      tag_key   = optional(string)
      tag_value = optional(list(string))
    }))) # Tags
  })
}

# 波动阈值变量
variable "wave_threshold_jsons" {
  description = "(Optional) Volatility reminder"
  type = list(object({
    warn_type   = optional(string) # ACTUAL: actual amount, FORECAST: forecast amount
    threshold   = optional(string) # Volatility threshold (greater than or equal to 0)
    meta_type   = optional(string) # Alarm type: chain month-on-month, yoy year-on-year, fix fixed value\n (Supported types: daily month-on-month chain day, daily month-on-year chain weekday, daily month-on-year monthly month-on-year fixed value fix day, month-on-month chain month, monthly fixed value fix month)
    period_type = optional(string) # Alarm dimension: day day, month month, weekday week\n (Support types: day-to-day chain day, day-to-year weekly dimension chain weekday, day-to-year monthly dimension yoy day, daily fixed value fix day, month-to-month chain month, monthly fixed value fix month)
  }))
}