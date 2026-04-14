variable "ccn_id" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = ""
}

variable "ccn_name" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = ""
}

variable "accept_attach_instances" {
  description = "Accept List Of Attachment Instances."
  type = list(object({
    instance_id     = string # Attachment Instance ID.
    instance_region = string # Instance Region.
    instance_type   = string # InstanceType: `VPC`, `DIRECTCONNECT`, `BMVPC`, `VPNGW`.
    description     = optional(string) # Description.
    route_table_id  = optional(string) # ID of the routing table associated with the instance. Note: This field may return null, indicating that no valid value can be obtained.
  }))
  default = []
}