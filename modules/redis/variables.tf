################################################################################
### Redis Instance Configuration
################################################################################
variable "vpc_id" {
  description = "ID of the vpc with which the instance is to be associated."
  type        = string
}

variable "subnet_id" {
  description = "Specifies which subnet the instance should belong to."
  type        = string
}

variable "password" {
  description = "Password for a Redis user, which should be 8 to 64 characters. Can only be null when no_auth=true."
  type        = string
  sensitive   = true
  default     = ""
}

variable "password_rotation_months" {
  description = "The root password rotation month"
  type        = number
  default     = 0 # set to larger than 0 to enable password rotation
}

variable "tags" {
  description = "Tags for the Redis instance."
  type        = map(string)
  default     = {}
}

variable "redis" {
  description = "Redis instance configuration object."
  type = object({
    # Required
    name              = string
    availability_zone = string
    mem_size          = number

    # Optional with defaults
    # Instance type:
    # 2: Redis 2.8 Memory Edition (Standard Architecture).
    # 3: CKV 3.2 Memory Edition (Standard Architecture).
    # 4: CKV 3.2 Memory Edition (Cluster Architecture).
    # 6: Redis 4.0 Memory Edition (Standard Architecture).
    # 7: Redis 4.0 Memory Edition (Cluster Architecture).
    # 8: Redis 5.0 Memory Edition (Standard Architecture).
    # 9: Redis 5.0 Memory Edition (Cluster Architecture).
    # 15: Redis 6.2 Memory Edition (Standard Architecture).
    # 16: Redis 6.2 Memory Edition (Cluster Architecture).
    # 17: Redis 7.0 Memory Edition (Standard Architecture).
    # 18: Redis 7.0 Memory Edition (Cluster Architecture).
    type_id = optional(number, 15)

    # Charge type: PREPAID or POSTPAID
    charge_type = optional(string, "POSTPAID")

    # Auto-renewal flag:
    # 0: Manual renewal 
    # 1: Auto-renewal (default).
    # 2: Not auto-renewal (set by user).
    auto_renew_flag = optional(number, 1)

    # The tenancy (time unit is month) of the prepaid instance.
    prepaid_period = optional(number, 1)

    # The port used to access a redis instance.
    port = optional(number, 6379)

    # The number of instance shards (for cluster architecture only).
    shard_num = optional(number, 1)

    # The number of instance copies.
    replicas_num = optional(number, 1)

    # Name of replica nodes available zone, e.g. ["ap-guangzhou-3", "ap-guangzhou-4"]
    replica_zone_names = optional(list(string), [])

    # Whether copy read-only is supported.
    replicas_read_only = optional(bool, false)

    # ID of security groups.
    security_groups = optional(list(string), [])

    # Indicate whether to delete Redis instance directly or not.
    force_delete = optional(bool, false)

    # The SSL configuration enabled or disabled.
    ssl_enabled = optional(bool, false)

    # Indicates whether the redis instance support no-auth access. NOTE: Only available in private cloud environment. Only no_auth=true can make password empty. Default to false.
    no_auth = optional(bool, false)

    password_length = optional(number, 32) # Password length. Default is 32.
  })

  validation {
    condition     = var.redis.mem_size > 0
    error_message = "The mem_size must be greater than 0."
  }

  validation {
    condition     = contains(["PREPAID", "POSTPAID"], var.redis.charge_type)
    error_message = "charge_type must be PREPAID or POSTPAID."
  }
}

variable "backup_strategy" {
  description = "Redis backup configuration. Set to null to disable backup."
  type = object({
    # Backup time period, e.g. "04:00-05:00"
    backup_time = string
  })
  default = null

  validation {
    condition     = var.backup_strategy == null || can(regex("^\\d{2}:\\d{2}-\\d{2}:\\d{2}$", var.backup_strategy.backup_time))
    error_message = "backup_time must be in format 'HH:MM-HH:MM', e.g. '04:00-05:00'."
  }
}

variable "storage_strategy" {
  description = "Redis storage configuration. Set to null to disable storage."
  type = object({
    storage_days = number # Number of days to store.0 specifies the default retention time.
    remark       = optional(string)
  })
  default = null

  validation {
    condition     = var.storage_strategy == null || var.storage_strategy.storage_days >= 0
    error_message = "storage_days must be greater than or equal to 0."
  }
}

# Whether to store Redis credentials in SSM
variable "store_credentials_in_ssm" {
  description = "Whether to store PostgreSQL credentials in SSM"
  type        = bool
  default     = false # default not store the password in SSM
}
