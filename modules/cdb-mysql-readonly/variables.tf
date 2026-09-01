################################################################################
### MySQL readonly variables
################################################################################
variable "ro_basic" {
  description = "MySQL readonly basic configuration"
  type = object({
    master_instance_id = string                     # Master instance ID
    master_region      = optional(string)           # Master instance region (required for cross-region readonly)
    ro_group_id        = optional(string)           # RO group ID. If set, all instances join this group; if empty, first instance creates new group
    zone               = optional(string)           # Availability zone
    vpc_id             = optional(string)           # VPC ID
    subnet_id          = optional(string)           # Subnet ID
    security_groups    = optional(list(string), []) # Security group IDs
    intranet_port      = optional(number)           # Intranet port
  })
  default = null
}

variable "ro_instances" {
  description = "MySQL readonly instances configuration, key is instance identifier"
  type = map(object({
    instance_name     = string                        # Instance name
    slave_deploy_mode = optional(number, 0)           # Deploy mode: 0 (single-zone), 1 (multi-zone)
    cpu               = number                        # CPU cores
    mem_size          = number                        # Memory size in MB
    volume_size       = number                        # Storage size in GB
    device_type       = optional(string, "UNIVERSAL") # Device type
    charge_type       = optional(string, "POSTPAID")  # Charge type: PREPAID or POSTPAID
    prepaid_period    = optional(number, 1)           # Prepaid period in months
    auto_renew_flag   = optional(number, 0)           # Auto-renew flag: 0 (off), 1 (on)
    force_delete      = optional(bool, false)         # Force delete instance
  }))
  default = {}
}

variable "tags" {
  description = "MySql Readonly instances tags"
  type        = map(string)
  default     = {}
}
