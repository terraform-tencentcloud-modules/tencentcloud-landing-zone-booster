# ccn
variable "name" {
  description = "Name of the CCN to be created, and maximum length does not exceed 60 bytes."
  type        = string
  default     = "ccn-example"
}

variable "bandwidth_limit_type" {
  description = "The speed limit type of CCN. Valid values: `INTER_REGION_LIMIT`, `OUTER_REGION_LIMIT`."
  type        = string
  default     = "OUTER_REGION_LIMIT"
}

variable "charge_type" {
  description = "Billing mode of CCN. Valid values: `PREPAID`, `POSTPAID`."
  type        = string
  default     = "POSTPAID"
}

variable "description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = ""
}

variable "qos" {
  description = "Service quality of CCN. Valid values: `PT`, `AU`, `AG`. The default is `AU`."
  type        = string
  default     = "AU"
}

variable "enable_route_ecmp" {
  description = "Whether to enable the equivalent routing function. true: enabled, false: disabled. Default is false."
  type        = bool
  default     = false
}

variable "enable_route_overlap" {
  description = "Whether to enable the routing overlap function. true: enabled, false: disabled. Default is true, cannot set to false."
  type        = bool
  default     = true
}

variable "instance_metering_type" {
  description = "Instance metering type. Valid values: BANDWIDTH (bandwidth billing), TRAFFIC (traffic billing). Default: 'BANDWIDTH'. This parameter cannot be modified after creation."
  type        = string
  default     = "BANDWIDTH"
}

variable "tags" {
  description = "Tags of the CCN to be created."
  type        = map(string)
  default     = {}
}