variable "mongodb_sharding" {
  description = "Mongodb sharding instance configuration"
  type = object({
    name                   = string                          # Instance name (instance_name). Also used for secret naming. Required.
    available_zone         = string                          # The availability zone of the instance, e.g. ap-singapore-2. Required.
    cpu                    = optional(number)                # Per-shard CPU core count. When empty, the default spec is used. Optional/Computed.
    memory                 = number                          # Per-shard memory size in GB (minimum 2). Memory and volume must be scaled together. Required.
    volume                 = number                          # Per-shard storage capacity in GB (minimum 25). Memory and volume must be scaled together. Required.
    machine_type           = optional(string, "HIO10G")      # Instance type. Use HIO or HIO10G (GIO/TGIO are deprecated aliases). ForceNew. Required.
    engine_version         = optional(string, "MONGO_50_WT") # Mongodb version: MONGO_40_WT, MONGO_42_WT, MONGO_44_WT, MONGO_50_WT, MONGO_60_WT, MONGO_70_WT, MONGO_80_WT, MONGO_83_WT. Required.
    shard_quantity         = number                          # Number of shards, range [2,20]. ForceNew. Required.
    nodes_per_shard        = number                          # Number of nodes per shard (3 = 1 primary + 2 secondary). Allowed: 3, 5, 7. ForceNew. Required.
    mongos_cpu             = optional(number, 1)             # Mongos CPU core count. Optional/Computed.
    mongos_memory          = optional(number, 2)             # Mongos memory size in GB. Optional/Computed.
    mongos_node_num        = optional(number, 3)             # Number of mongos nodes. Optional/Computed.
    availability_zone_list = optional(list(string))          # A list of nodes deployed in multiple availability zones (cross-AZ). Optional/Computed.
    hidden_zone            = optional(string)                # The availability zone to which the Hidden node belongs. Required in cross-AZ deployment.
    add_node_list = optional(list(object({                   # Add node list. Node type and availability zone information.
      role = string                                          # Node role to add. Valid: SECONDARY (Mongod node), READONLY (read-only node), MONGOS (Mongos node).
      zone = string                                          # The availability zone for the new node.
    })))
    remove_node_list = optional(list(object({ # Remove node list. Based on shard 0 node consistency.
      role      = string                      # Node role to remove. Valid: SECONDARY, READONLY, MONGOS.
      node_name = string                      # Node ID to remove, e.g. cmgo-xxxx_0-node-readonly0.
      zone      = string                      # The availability zone of the node to remove.
    })))
    in_maintenance           = optional(number)                     # Switch time for instance config changes. 0: immediately (default); 1: within maintenance window. Note: shard/node count changes do not support the maintenance window.
    vpc_id                   = optional(string)                     # VPC ID. Must be set together with subnet_id. ForceNew.
    subnet_id                = optional(string)                     # Subnet ID. Must be set together with vpc_id. ForceNew.
    charge_type              = optional(string, "POSTPAID_BY_HOUR") # Billing mode. PREPAID or POSTPAID_BY_HOUR. ForceNew.
    prepaid_period           = optional(number, 1)                  # The tenancy (time unit is month) of the prepaid instance. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36. NOTE: it only works when charge_type is set to PREPAID.
    project_id               = optional(number, 0)                  # ID of the project which the instance belongs to.
    auto_renew_flag          = optional(number, 0)                  # Auto renew flag. Valid values are 0(NOTIFY_AND_MANUAL_RENEW), 1(NOTIFY_AND_AUTO_RENEW) and 2(DISABLE_NOTIFY_AND_MANUAL_RENEW). Default value is 0. Note: only works for PREPAID instance.
    user_name                = optional(string)                     # The new account name
    user_desc                = optional(string, "")                 # new user account remarks.
    enable_ssl               = optional(bool, false)                # Whether to enable SSL
    enable_encryption        = optional(bool, false)                # Whether to enable mongodb transparent data encryption (via the dedicated TDE resource).
    data_encryption          = optional(string)                     # Database storage encryption setting on the instance: "No_Encryption" or "TDE". Immutable. Used at creation time.
    encryption_key_source    = optional(string)                     # KMS key source when TDE is selected: "auto" (auto-generate) or "manual" (specify key). Immutable.
    kms_region               = optional(string)                     # The region where the Key Management Service (KMS) serves, such as ap-shanghai.
    kms_key_id               = optional(string)                     # Key ID (CMK alias). If empty and manual source, Tencent Cloud auto-generates a key (not managed by Terraform).
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
