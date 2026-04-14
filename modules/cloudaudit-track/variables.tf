###############
# Cloud Audit
###############
variable "track_name" {
  type        = string
  default     = ""
  description = "The name of cloud audit track."
}

variable "action_type" {
  type        = string
  default     = "*"
  description = "Track interface type, optional: (Read: Read interface, Write: Write interface, *: All interface),  Default is *."
}

variable "resource_type" {
  type        = string
  default     = "*"
  description = "Track product, optional: (*: All product, Single product, such as cos), Default is *."
}

variable "event_names" {
  type        = list(string)
  default     = ["*"]
  description = "Track interface name list. When resource_type is *, event_names is must *; When resource_type is a single product, event_names support all interfaces(*) and some interfaces, up to 10."
}

variable "track_for_all_members" {
  type        = number
  default     = 1
  description = "Whether to enable the delivery of group member operation logs to the group management account or trusted service management account, optional: (close: 0, open: 1)."
}

variable "status" {
  type        = number
  default     = 1
  description = "Track status, optional: (close: 0, open: 1)."
}

######################
# Cloud Audit Storage
######################
variable "storage_type" {
  type        = string
  description = "Track Storage type, optional: cos, cls, ckafka."
}

variable "storage_region" {
  type        = string
  description = "The region of storage."
}

variable "storage_name" {
  type        = string
  description = "The name of the bucket."
}

variable "storage_prefix" {
  type        = string
  description = "Storage path prefix."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "Designated to store user ID."
}

variable "storage_app_id" {
  type        = string
  default     = null
  description = "Your appid."
}