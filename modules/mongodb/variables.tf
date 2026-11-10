variable "mongodb_instance" {
  description = "Mongodb instance configuration"
  type = object({
    name                     = string                               # Instance name used for secret naming
    available_zone           = string                               # The availability zone of the instance. For example, ap-singapore-2.     
    memory                   = optional(number, 4)                  # Memory size in GB.      
    volume                   = optional(number, 100)                # Storage capacity in GB.
    machine_type             = optional(string, "HIO10G")           # Type of Mongodb instance, and available values include HIO and HIO10G
    engine_version           = optional(string, "MONGO_50_WT")      # Version of the Mongodb, and available values like MONGO_50_WT (MongoDB 5.0 WiredTiger Edition), MONGO_40_WT (MongoDB 4.0 WiredTiger Edition) 
    auto_renew_flag          = optional(number, 0)                  # Auto renew flag. Valid values are 0(NOTIFY_AND_MANUAL_RENEW), 1(NOTIFY_AND_AUTO_RENEW) and 2(DISABLE_NOTIFY_AND_MANUAL_RENEW). Default value is 0. Note: only works for PREPAID instance.
    availability_zone_list   = list(string)                         # A list of nodes deployed in multiple availability zones.
    hidden_zone              = optional(string)                     # The availability zone to which the Hidden node belongs. 
    node_num                 = optional(number, 3)                  # The number of nodes in each replica set. at least 3 for replicas set.Default value: 3.
    vpc_id                   = string                               # VPC ID
    subnet_id                = string                               # subnet ID
    charge_type              = optional(string, "POSTPAID_BY_HOUR") # Billing mode. POSTPAID_BY_HOUR: Pay-As-You-Go
    prepaid_period           = optional(number, 1)                  # The tenancy (time unit is month) of the prepaid instance. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36. NOTE: it only works when charge_type is set to PREPAID.
    user_name                = optional(string)                     # The new account name
    user_desc                = optional(string, "")                 # new user account remarks.
    enable_ssl               = optional(bool, false)                # Whether to enable SSL
    enable_encryption        = optional(bool, false)                # Whether to enable mongodb transparent data encryption
    kms_region               = optional(string)                     # The region where the Key Management Service (KMS) serves, such as ap-shanghai.
    kms_key_id               = optional(string)                     # Key ID. If this parameter is not set and the specific key ID is not specified, Tencent Cloud will automatically generate the key and this key will be beyond the control of Terraform.
    security_group_ids       = optional(list(string), [])           # List of security group IDs to attach to the MongoDB instance.
    password_length          = optional(number, 32)                 # Length of auto-generated passwords.
    password_rotation_months = optional(number, 0)                  # Password rotation period in months. 0 means disabled.
  })
}

variable "create_kms_strategy" {
  description = "Whether to create kms strategy for postgres to use kms"
  type        = bool
  default     = false
}

variable "system_user_password" {
  description = "Password of this Mongodb root account. Leave empty to auto-generate."
  type        = string
  sensitive   = true
  default     = ""
}

variable "tags" {
  description = "The tags of the Mongodb."
  type        = map(string)
  default     = {}
}

variable "user_password" {
  description = "Password of a new user account. Leave empty to auto-generate."
  type        = string
  sensitive   = true
  default     = ""
}

variable "auth_roles" {
  description = "List of read and write permission information of the account. Each item contains mask and namespace."
  type = list(object({
    mask      = optional(number, 3)   # Permission information of the current account. 0: No permission. 1: read-only. 2: Write only. 3: Read and write.
    namespace = optional(string, "*") # Refers to the name of the database with the current account permissions.*: Indicates all databases. db.name: Indicates the database of a specific name.
  }))
  default = [{}]
}

# Whether to store mongodb credentials in SSM
variable "store_credentials_in_ssm" {
  description = "Whether to store PostgreSQL credentials in SSM"
  type        = bool
  default     = true
}

# MongoDB backup configuration
variable "backup" {
  description = "MongoDB instance backup rule configuration"
  type = object({
    enabled                 = optional(bool, true) # Whether to enable backup rule
    backup_method           = optional(number, 1)  # Backup method: 0(logical backup), 1(physical backup), 3(snapshot backup). Note: logical/physical for general instances, physical/snapshot for cloud disk instances.
    backup_time             = optional(number, 2)  # Auto backup start time, range [0,23] (hour), e.g., 2 means 02:00.
    backup_retention_period = optional(number, 7)  # Backup data retention period in days, range [7,365], default 7.
    backup_version          = optional(number, 1)  # Backup version: 0(old version), 1(advanced backup, recommended).
    backup_frequency        = optional(number, 24) # Daily backup frequency: 12(twice daily, ~12h interval), 24(once daily, default).
  })
  default = {
    enabled                 = true
    backup_method           = 1
    backup_time             = 2
    backup_retention_period = 7
    backup_version          = 1
    backup_frequency        = 24
  }
}
