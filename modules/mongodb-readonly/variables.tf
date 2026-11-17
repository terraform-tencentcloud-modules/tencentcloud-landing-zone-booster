variable "mongodb_readonly" {
  description = "Mongodb readonly (read-only replica) instance configuration"
  type = object({
    name                   = string                               # Instance name (instance_name). Also used for secret naming. Required.
    father_instance_id     = string                               # The ID of the primary instance this readonly replicates from. ForceNew. Required.
    father_instance_region = string                               # The region of the primary instance. ForceNew. Required.
    cluster_type           = string                               # Instance schema type. REPLSET: Replset cluster; SHARD: Shard cluster. ForceNew. Required.
    available_zone         = string                               # The availability zone of the readonly instance. Required.
    cpu                    = optional(number)                     # CPU core count of the readonly instance. When empty, the default spec is used.
    memory                 = number                               # Memory size in GB (minimum 2). Memory and volume must be scaled together. Required.
    volume                 = number                               # Storage capacity in GB (minimum 25). Memory and volume must be scaled together. Required.
    engine_version         = string                               # MongoDB version (e.g. MONGO_80_WT). Required. Allowed: MONGO_40_WT, MONGO_42_WT, MONGO_44_WT, MONGO_50_WT, MONGO_60_WT, MONGO_70_WT, MONGO_80_WT, MONGO_83_WT.
    machine_type           = string                               # Instance type. Allowed: HIO (or deprecated GIO), HIO10G (or deprecated TGIO). ForceNew. Required.
    node_num               = optional(number, 3)                  # Number of nodes in each replica set. Default 3. Optional/Computed.
    shard_quantity         = optional(number)                     # Number of shards. Range [2,20]. Only for SHARD. ForceNew.
    nodes_per_shard        = optional(number)                     # Number of nodes per shard, range [3,5]. Only for SHARD. ForceNew.
    mongos_cpu             = optional(number)                     # Mongos CPU core count. Only for SHARD.
    mongos_memory          = optional(number)                     # Mongos memory size in GB. Only for SHARD.
    mongos_node_num        = optional(number)                     # Number of mongos nodes. Only for SHARD.
    vpc_id                 = optional(string)                     # VPC ID. Must be set together with subnet_id.
    subnet_id              = optional(string)                     # Subnet ID. Must be set together with vpc_id.
    in_maintenance         = optional(number)                     # Switch time for instance config changes. 0: immediately (default); 1: within maintenance window. Note: node/shard count changes do not support maintenance-window.
    charge_type            = optional(string, "POSTPAID_BY_HOUR") # Billing mode. PREPAID or POSTPAID_BY_HOUR. ForceNew.
    prepaid_period         = optional(number, 1)                  # The tenancy (time unit is month) of the prepaid instance. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36. NOTE: it only works when charge_type is set to PREPAID.
    project_id             = optional(number, 0)                  # ID of the project which the instance belongs to.
    auto_renew_flag        = optional(number, 0)                  # Auto renew flag. Valid values are 0(NOTIFY_AND_MANUAL_RENEW), 1(NOTIFY_AND_AUTO_RENEW) and 2(DISABLE_NOTIFY_AND_MANUAL_RENEW). Default value is 0. Note: only works for PREPAID instance.
    security_group_ids     = optional(list(string), [])           # List of security group IDs to attach to the MongoDB instance.
    data_encryption        = optional(string)                     # Transparent data encryption mode: "TDE" or "No_Encryption". Immutable.
    encryption_key_source  = optional(string)                     # The source of the encryption key. Valid values: "manual", "kms".
    kms_region             = optional(string)                     # The region where the Key Management Service (KMS) serves, such as ap-shanghai.
    kms_key_id             = optional(string)                     # Key ID. If this parameter is not set and the specific key ID is not specified, Tencent Cloud will automatically generate the key and this key will be beyond the control of Terraform.
    user_name              = optional(string)                     # The new account name
    user_desc              = optional(string, "")                 # new user account remarks.
    enable_ssl             = optional(bool, false)                # Whether to enable SSL
    password_length        = optional(number, 32)                 # Length of auto-generated passwords (used for SSM storage; the readonly password is inherited from the primary instance).
  })
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
