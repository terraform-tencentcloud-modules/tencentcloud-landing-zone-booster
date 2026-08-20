################################################################################
### Postgres readonly variables
################################################################################
variable "ro_group" {
  description = "PostgreSQL readonly group configuration"
  type = object({
    name                        = string                     # Readonly group name
    master_db_instance_id       = string                     # Master instance ID
    project_id                  = optional(number, 0)        # Project ID
    vpc_id                      = string                     # VPC ID
    subnet_id                   = string                     # Subnet ID
    security_groups_ids         = optional(list(string), []) # Security group IDs
    replay_lag_eliminate        = optional(number, 0)        # Enable lag-based elimination. 0: no, 1: yes
    replay_latency_eliminate    = optional(number, 0)        # Enable latency-based elimination. 0: no, 1: yes
    max_replay_lag              = optional(number, 0)        # Lag threshold in milliseconds
    max_replay_latency          = optional(number, 0)        # Latency threshold in MB
    min_delay_eliminate_reserve = optional(number, 1)        # Minimum reserved readonly instances
  })
  default = null
}

variable "ro_instances" {
  description = "PostgreSQL readonly instances configuration, key is instance identifier"
  type = map(object({
    name              = string                               # Instance name
    zone              = string                               # Availability zone
    db_version        = string                               # PostgreSQL version, must match master
    charge_type       = optional(string, "POSTPAID_BY_HOUR") # Billing mode: PREPAID or POSTPAID_BY_HOUR
    memory            = number                               # Memory size in GB
    cpu               = number                               # CPU cores
    storage           = number                               # Storage capacity in GB
    need_support_ipv6 = optional(number, 0)                  # IPv6 support. 0: no, 1: yes
    auto_renew_flag   = optional(number)                     # Auto-renew flag for PREPAID. 0: off, 1: on
  }))
  default = {}
}

variable "tags" {
  description = "Readonly instances tags"
  type        = map(string)
  default     = {}
}
