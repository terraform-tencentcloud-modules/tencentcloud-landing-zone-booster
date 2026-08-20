################################################################################
### Postgres Instance variables
################################################################################
variable "postgres_instance" {
  description = "The postgres instance input variables"
  type = object({
    name              = string # Instance name
    availability_zone = string # The availability zone of the instance.

    vpc_id            = string                           # VPC ID
    subnet_id         = string                           # Subnet ID
    memory            = number                           # Memory size in GB.
    storage           = number                           # Storage capacity in GB.
    cpu               = optional(number, 4)              # Number of CPU cores. Default is 1.
    db_kernel_version = optional(string, "v14.19_r1.38") # Database kernel version. eg. v11.12_r1.3.
    engine_version    = optional(string, "14.19")        # Database version. eg. 13.3.

    standby_availability_zone = optional(string)                     # The standby availability zone of the instance.
    readonly_enable           = optional(bool, false)                # Whether to enable the standby instance. Default is false.
    charge_type               = optional(string, "POSTPAID_BY_HOUR") # Billing mode. POSTPAID_BY_HOUR: Pay-As-You-Go, PREPAID: Prepaid.
    period                    = optional(number)                     # Prepaid period in months. Valid values: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36.
    auto_renew_flag           = optional(number, 0)                  # Auto renew flag. 0: not auto renew, 1: auto renew. Default is 0.
    auto_voucher              = optional(number, 0)                  # Whether to use voucher. 0: not use, 1: use. Default is 0.

    delete_protection           = optional(bool, true) # Whether to enable deletion protection. Default is true.
    max_standby_archive_delay   = optional(number)     # Units are milliseconds if not specified.
    max_standby_streaming_delay = optional(number)     # Units are milliseconds if not specified.

    charset         = optional(string, "UTF8") # Database character set. Default is UTF8.
    security_groups = optional(set(string))    # Security group ID list.
    project_id      = optional(number, 0)      # Project ID

    # backup plan
    backup_plan = optional(list(object({
      min_backup_start_time        = optional(string)       # Specify earliest backup start time, format hh:mm:ss
      max_backup_start_time        = optional(string)       # Specify latest backup start time, format hh:mm:ss
      base_backup_retention_period = optional(number)       # Specify days of the retention.
      backup_period                = optional(list(string)) # List of backup period per week, available values: monday, tuesday, wednesday, thursday, friday, saturday, sunday. NOTE: At least specify two days.
    })))

    need_support_tde = optional(number, 0)   # Whether to enable TDE. Default is 0.
    kms_key_id       = optional(string)      # KMS key ID.
    kms_region       = optional(string)      # KMS key region.
    ssl_enable       = optional(bool, false) # Whether to enable SSL. Default is false.
    password_length  = optional(number, 32)  # Password length. Default is 64.
  })

  validation {
    condition = var.postgres_instance.backup_plan == null || alltrue([
      for bp in var.postgres_instance.backup_plan : bp.backup_period == null || alltrue([
        for day in bp.backup_period : contains(["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"], day)
      ])
    ])
    error_message = "backup_period must only contain valid values: monday, tuesday, wednesday, thursday, friday, saturday, sunday."
  }

  validation {
    condition = var.postgres_instance.backup_plan == null || alltrue([
      for bp in var.postgres_instance.backup_plan : bp.backup_period == null || length(bp.backup_period) >= 2
    ])
    error_message = "backup_period must contain at least 2 days."
  }
}

variable "root_user" {
  description = "Instance root account name. This parameter is optional, Default value is root"
  type        = string
  default     = "root"
}

variable "root_password" {
  description = "Instance root account password. The password must be 8-32 characters long and contain at least two of the following types of characters: letters, digits, and special characters."
  type        = string
  sensitive   = true
  default     = ""
}

variable "root_password_rotation_months" {
  description = "The root password rotation month"
  type        = number
  default     = 0 # set to larger than 0 to enable password rotation
}

# Whether to store PostgreSQL credentials in SSM
variable "store_credentials_in_ssm" {
  description = "Whether to store PostgreSQL credentials in SSM"
  type        = bool
  default     = true # default to true to avoid breaking changes
}

variable "random_password_length" {
  description = "The maximum length of generated password"
  type        = number
  default     = 12
}

variable "random_password_special" {
  description = "Whether the generate password contain special character"
  type        = bool
  default     = true
}

variable "random_password_min_special" {
  description = "Minimum special character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_upper" {
  description = "Minimum upper case character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_lower" {
  description = "Minimum lower case character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_numeric" {
  description = "Minimum numeric character in random password"
  type        = number
  default     = 1
}

# variable "postgresql_parameters" {
#   description = "PostgreSQL parameters"
#   type = list(object({
#     name  = string
#     value = string
#   }))
#   default = {
#     name  = "timezone"
#     value = "UTC"
#   }
# }

variable "users" {
  description = "Whether create custom user for database"
  type = map(object({
    password = optional(string)
    type     = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
