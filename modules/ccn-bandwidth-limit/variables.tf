# ccn bandwidth limit
variable "ccn_id" {
  description = "The ID of ccn which to attach."
  type        = string
}

variable "src_region" {
  description = "Limitation of region."
  type        = string
}

variable "dst_region" {
  description = "Destination area restriction. If the `CCN` rate limit type is `OUTER_REGION_LIMIT`, this value does not need to be set."
  type        = string
}

variable "bandwidth_limit" {
  description = "Limitation of bandwidth."
  type        = number
  default     = 0
}