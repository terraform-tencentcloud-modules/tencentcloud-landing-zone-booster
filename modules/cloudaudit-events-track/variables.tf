###############
# Cloud Audit
###############
variable "track_name" {
  type        = string
  description = "The name of cloud audit track."
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

######################
# Cloud Audit Filters
######################
variable "audit_filters" {
  description = "Data filtering criteria."
  type = list(object({
    resource_type = string       # The product to which the tracking set event belongs. The value can be a single product such as `cos`, or `*` that indicates all products.
    action_type   = string       # Tracking set event type (`Read`: Read; `Write`: Write; `*`: All).
    event_names   = list(string) # The list of API names of tracking set events. When `ResourceType` is `*`, the value of `EventNames` must be `*`. When `ResourceType` is a specified product, the value of `EventNames` can be `*`. When `ResourceType` is `cos` or `cls`, up to 10 APIs are supported.
  }))
}