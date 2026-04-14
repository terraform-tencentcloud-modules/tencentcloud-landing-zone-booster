################################################################################
# CCN config
################################################################################
variable "ccn_name" {
  description = "Name of the CCN to be created, and maximum length does not exceed 60 bytes."
  type        = string
}

variable "ccn_bandwidth_limit_type" {
  description = "The speed limit type of CCN. Valid values: `INTER_REGION_LIMIT`, `OUTER_REGION_LIMIT`."
  type        = string
  default     = "OUTER_REGION_LIMIT"
}

variable "ccn_charge_type" {
  description = "Billing mode of CCN. Valid values: `PREPAID`, `POSTPAID`."
  type        = string
  default     = "POSTPAID"
}

variable "ccn_description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
}

variable "ccn_qos" {
  description = "Service quality of CCN. Valid values: `PT`, `AU`, `AG`. The default is `AU`."
  type        = string
  default     = "AU"
}

variable "ccn_tags" {
  description = "Tags of the CCN to be created."
  type        = map(string)
  default     = {}
}

# ccn bandwidth limit
variable "ccn_set_bandwith_limit" {
  description = "Control if set ccn bandwidth limit."
  type        = bool
  default     = false
}

variable "ccn_region" {
  description = "Limitation of region."
  type        = string
  default     = null
}

variable "ccn_dst_region" {
  description = "Destination area restriction. If the `CCN` rate limit type is `OUTER_REGION_LIMIT`, this value does not need to be set."
  type        = string
  default     = null
}

variable "ccn_bandwidth_limit" {
  description = "Limitation of bandwidth."
  type        = number
  default     = 0
}