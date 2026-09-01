# ============================================================
# TencentDB for MySQL instance variables
# Source: tencentcloud_mysql_instance provider schema
# Deprecated excluded: pay_type, period  -> use charge_type / prepaid_period
# ============================================================
variable "instance_id" {
  description = "The id of a mysql instance."
  type        = string
  default     = null
}

variable "project_id" {
  description = "Project ID. Default 0."
  type        = number
  default     = 0
}

# ---------------- Required ----------------
variable "instance_name" {
  description = "The name of a MySQL instance."
  type        = string
  validation {
    condition     = length(var.instance_name) >= 1 && length(var.instance_name) <= 100
    error_message = "instance_name must be 1-100 characters."
  }
}

variable "cpu_cores" {
  description = "CPU cores. Computed if omitted."
  type        = number
  default     = null
}

variable "mem_size" {
  description = "Memory size (in MB)."
  type        = number
}

variable "volume_size" {
  description = "Disk size (in GB)."
  type        = number
}

# ---------------- Billing ----------------
variable "charge_type" {
  description = "Pay type. Valid values: PREPAID, POSTPAID. ForceNew."
  type        = string
  default     = "POSTPAID"
  validation {
    condition     = contains(["PREPAID", "POSTPAID"], var.charge_type)
    error_message = "charge_type must be PREPAID or POSTPAID."
  }
}

variable "prepaid_period" {
  description = "Period (months). Only for PREPAID. Default 1."
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36], var.prepaid_period)
    error_message = "prepaid_period must be in 1-12, 24, 36."
  }
}

variable "auto_renew_flag" {
  description = "Auto renew flag (0/1). Only for PREPAID."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1], var.auto_renew_flag)
    error_message = "auto_renew_flag must be 0 or 1."
  }
}

# ---------------- Zone / HA ----------------
variable "availability_zone" {
  description = "Availability zone to use."
  type        = string
  default     = null
}

variable "root_password" {
  description = "Root account password. Sensitive. Ignore for read-only/disaster recovery instances."
  type        = string
  sensitive   = true
  default     = null
}

variable "slave_deploy_mode" {
  description = "AZ deploy mode. 0 - Single AZ; 1 - Multiple AZ. Not supported for readonly instances."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1], var.slave_deploy_mode)
    error_message = "slave_deploy_mode must be 0 or 1."
  }
}

variable "first_slave_zone" {
  description = "Zone of the first slave instance."
  type        = string
  default     = null
}

variable "second_slave_zone" {
  description = "Zone of the second slave instance."
  type        = string
  default     = null
}

variable "slave_sync_mode" {
  description = "Data replication mode. 0 - Async; 1 - Semisync; 2 - Strongsync."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 2], var.slave_sync_mode)
    error_message = "slave_sync_mode must be 0, 1 or 2."
  }
}

# ---------------- Network ----------------
variable "intranet_port" {
  description = "Intranet access port, range [1024-65535]. Default 3306."
  type        = number
  default     = 3306
  validation {
    condition     = var.intranet_port >= 1024 && var.intranet_port <= 65535
    error_message = "intranet_port must be between 1024 and 65535."
  }
}

variable "vpc_id" {
  description = "ID of VPC. Can be modified once per 24h, cannot be removed."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Private network ID. Required when vpc_id is set."
  type        = string
  default     = null
}

variable "security_groups" {
  description = "Security groups to use."
  type        = list(string)
  default     = []
}

# ---------------- Spec ----------------
variable "param_template_id" {
  description = "Specify parameter template id."
  type        = number
  default     = null
}

variable "fast_upgrade" {
  description = "Fast upgrade on spec change. 1 enabled, 0 disabled."
  type        = number
  default     = null
}

variable "device_type" {
  description = "Device type: UNIVERSAL (default), EXCLUSIVE, BASIC_V2, CLOUD_NATIVE_CLUSTER, CLOUD_NATIVE_CLUSTER_EXCLUSIVE."
  type        = string
  default     = null
  validation {
    condition     = var.device_type == null || contains(["UNIVERSAL", "EXCLUSIVE", "BASIC_V2", "CLOUD_NATIVE_CLUSTER", "CLOUD_NATIVE_CLUSTER_EXCLUSIVE"], var.device_type)
    error_message = "Invalid device_type."
  }
}

variable "disk_type" {
  description = "Disk type (ForceNew): CLOUD_SSD, CLOUD_HSSD, CLOUD_PREMIUM."
  type        = string
  default     = null
  validation {
    condition     = var.disk_type == null || contains(["CLOUD_SSD", "CLOUD_HSSD", "CLOUD_PREMIUM"], var.disk_type)
    error_message = "Invalid disk_type."
  }
}

# ---------------- Behavior ----------------
variable "force_delete" {
  description = "Force delete directly (skip recycle bin). Only for PREPAID."
  type        = bool
  default     = false
}

variable "wait_switch" {
  description = "Switch method to new instance. 0 immediate, 1 in time window."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1], var.wait_switch)
    error_message = "wait_switch must be 0 or 1."
  }
}

variable "destroy_protect" {
  description = "Destroy protection status: on (enable), off (disable)."
  type        = string
  default     = null
  validation {
    condition     = var.destroy_protect == null || contains(["on", "off"], var.destroy_protect)
    error_message = "destroy_protect must be on or off."
  }
}

# ---------------- Cluster Edition topology ----------------
variable "cluster_topology" {
  description = "Cluster Edition node topology. Required for cluster edition. RO nodes 1-5."
  type = list(object({
    read_write_node = optional(object({
      zone    = string
      node_id = optional(string)
    }))
    read_only_nodes = optional(list(object({
      is_random_zone = optional(bool)
      zone           = optional(string)
      node_id        = optional(string)
    })))
  }))
  default = []
}

# ---------------- Parameters & Engine ----------------
variable "parameters" {
  description = "List of parameters to use (key-value map)."
  type        = map(string)
  default     = null
}

variable "internet_service" {
  description = "Enable public network access. 0 - No, 1 - Yes."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1], var.internet_service)
    error_message = "internet_service must be 0 or 1."
  }
}

variable "engine_version" {
  description = "Database engine version. Supported: 5.5/5.6/5.7/8.0/8.4. Default 5.7."
  type        = string
  default     = "5.7"
  validation {
    condition     = contains(["5.5", "5.6", "5.7", "8.0", "8.4"], var.engine_version)
    error_message = "engine_version must be one of 5.5/5.6/5.7/8.0/8.4."
  }
}

variable "engine_type" {
  description = "Instance engine type. InnoDB (default) or RocksDB."
  type        = string
  default     = "InnoDB"
  validation {
    condition     = var.engine_type == null || contains(["InnoDB", "RocksDB"], var.engine_type)
    error_message = "engine_type must be InnoDB or RocksDB."
  }
}

variable "upgrade_subversion" {
  description = "Kernel subversion upgrade flag. 1 - upgrade subversion; 0 - upgrade engine version. Only for upgrade ops."
  type        = number
  default     = null
}

variable "max_deay_time" {
  description = "Latency threshold (1~10). Only for upgrade kernel subversion and engine version. NOTE: provider schema typo (deay)."
  type        = number
  default     = null
  validation {
    condition     = var.max_deay_time == null || (var.max_deay_time >= 1 && var.max_deay_time <= 10)
    error_message = "max_deay_time must be between 1 and 10."
  }
}

variable "tags" {
  description = "Instance tags."
  type        = map(string)
  default     = {}
}

##################################################
# resource: tencentcloud_mysql_backup_policy
##################################################
variable "create_backup_policy" {
  description = "Whether to create mysql backup policy."
  type        = bool
  default     = false
}

variable "backup_model" {
  description = "Backup method. Supported values include: 'physical' - physical backup."
  type        = string
  default     = "physical"
}

variable "backup_time" {
  description = "Instance backup time, in the format of \"HH:mm-HH:mm\". Time setting interval is four hours. Default to \"02:00-06:00\". The following value can be supported: 02:00-06:00, 06:00-10:00, 10:00-14:00, 14:00-18:00, 18:00-22:00, and 22:00-02:00."
  type        = string
  default     = "02:00-06:00"
}

variable "retention_period" {
  description = "Instance backup retention days. Valid values: [7-730]. And default value is 7."
  type        = number
  default     = 7
}

variable "binlog_period" {
  description = "Binlog retention time, in days. The minimum value is 7 days and the maximum value is 1830 days. This value cannot be set greater than the backup file retention time."
  type        = number
  default     = 7
}

variable "enable_binlog_standby" {
  description = "Whether to enable the log backup standard storage policy, `off` - close, `on` - open, the default is off."
  type        = string
  default     = "off"
}

variable "binlog_standby_days" {
  description = "The standard starting number of days for log backup storage. The log backup will be converted when it reaches the standard starting number of days for storage. The minimum is 30 days and must not be greater than the number of days for log backup retention."
  type        = number
  default     = null
}

##################################################
# resource: tencentcloud_mysql_database
##################################################
variable "databases" {
  description = "databases of mysql instance"
  type = list(object({
    db_name            = string
    character_set_name = string
  }))
  default = []

  validation {
    condition = alltrue([
      for db in var.databases : contains(["utf8", "gbk", "latin1", "utf8mb4"], db.character_set_name)
    ])
    error_message = "Invalid value for character_set_name. Valid values: `utf8`, `gbk`, `latin1`, `utf8mb4`."
  }
}

##################################################
# resource: tencentcloud_mysql_account
##################################################
variable "mysql_accounts" {
  description = "Multiple account instances.Every element of the list contains a tencentcloud_mysql_account configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_account.html for configuration guide."
  type = list(object({
    name                 = string # Account name.
    password             = optional(string, null) # Operation password.
    host                 = optional(string, "%") # Account host, default is `%`.
    description          = optional(string, "--") # Database description. Default is `--`.
    max_user_connections = optional(number, 10240) # The maximum number of available connections for a new account, the default value is 10240, and the maximum value that can be set is 10240.
    
    # Global privileges. Available values for Privileges:
    #   SELECT, INSERT, UPDATE, DELETE, CREATE, PROCESS,
    #   DROP, REFERENCES, INDEX, ALTER, SHOW DATABASES,
    #   CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE,
    #   CREATE VIEW, SHOW VIEW, CREATE ROUTINE,
    #   ALTER ROUTINE, EVENT, TRIGGER, REPLICATION SLAVE,
    #   REPLICATION CLIENT
    global = set(string)

    # Database privileges list. Privileges:
    #   SELECT, INSERT, UPDATE, DELETE, CREATE,
    #   DROP, REFERENCES, INDEX, ALTER,
    #   CREATE TEMPORARY TABLES, LOCK TABLES,
    #   EXECUTE, CREATE VIEW, SHOW VIEW,
    #   CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER
    database = optional(list(object({
      database_name = string
      privileges    = set(string)
    })), [])

    # Table privileges list. Privileges:
    #   SELECT, INSERT, UPDATE, DELETE, CREATE,
    #   DROP, REFERENCES, INDEX, ALTER,
    #   CREATE VIEW, SHOW VIEW, TRIGGER
    table = optional(list(object({
      database_name = string
      table_name    = string
      privileges    = set(string)
    })), [])

    # Column privileges list. Privileges:
    #   SELECT, INSERT, UPDATE, REFERENCES
    column = optional(list(object({
      database_name = string
      table_name    = string
      column_name   = string
      privileges    = set(string)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for account in var.mysql_accounts : account.name != null && account.name != ""
    ])
    error_message = "Invalid value for name. The account name must not be empty."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts : !contains(["root", "mysql.sys", "tencentroot"], account.name)
    ])
    error_message = "Invalid value for name. The following account names are forbidden: root, mysql.sys, tencentroot"
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts : account.password == null || (length(account.password) >= 8 && length(account.password) <= 32)
    ])
    error_message = "Invalid value for password. The password length must be between 8 and 32 characters."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts : account.max_user_connections >= 1 && account.max_user_connections <= 10240
    ])
    error_message = "Invalid value for max_user_connections. The value must be between 1 and 10240."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts : length(account.global) > 0
    ])
    error_message = "Invalid configuration: global privileges must contain at least one privilege."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts :
      alltrue([
        for g in account.global :
        contains([
          "SELECT",
          "INSERT",
          "UPDATE",
          "DELETE",
          "CREATE",
          "PROCESS",
          "DROP",
          "REFERENCES",
          "INDEX",
          "ALTER",
          "SHOW DATABASES",
          "CREATE TEMPORARY TABLES",
          "LOCK TABLES",
          "EXECUTE",
          "CREATE VIEW",
          "SHOW VIEW",
          "CREATE ROUTINE",
          "ALTER ROUTINE",
          "EVENT",
          "TRIGGER",
          "REPLICATION SLAVE",
          "REPLICATION CLIENT"
        ], g)
      ])
    ])
    error_message = "Invalid value in global privileges."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts :
      alltrue([
        for db in account.database :
        alltrue([
          for p in db.privileges :
          contains([
            "SELECT",
            "INSERT",
            "UPDATE",
            "DELETE",
            "CREATE",
            "DROP",
            "REFERENCES",
            "INDEX",
            "ALTER",
            "CREATE TEMPORARY TABLES",
            "LOCK TABLES",
            "EXECUTE",
            "CREATE VIEW",
            "SHOW VIEW",
            "CREATE ROUTINE",
            "ALTER ROUTINE",
            "EVENT",
            "TRIGGER"
          ], p)
        ])
      ])
    ])
    error_message = "Invalid value in database privileges."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts :
      alltrue([
        for tb in account.table :
        alltrue([
          for p in tb.privileges :
          contains([
            "SELECT",
            "INSERT",
            "UPDATE",
            "DELETE",
            "CREATE",
            "DROP",
            "REFERENCES",
            "INDEX",
            "ALTER",
            "CREATE VIEW",
            "SHOW VIEW",
            "TRIGGER"
          ], p)
        ])
      ])
    ])
    error_message = "Invalid value in table privileges."
  }

  validation {
    condition = alltrue([
      for account in var.mysql_accounts :
      alltrue([
        for col in account.column :
        alltrue([
          for p in col.privileges :
          contains([
            "SELECT",
            "INSERT",
            "UPDATE",
            "REFERENCES"
          ], p)
        ])
      ])
    ])
    error_message = "Invalid value in column privileges."
  }
}

##################################################
# resource: tencentcloud_mysql_privilege
##################################################
# variable "mysql_privileges" {
#   description = "Multiple privilege configuration instances.Every element of the list contains a tencentcloud_mysql_privilege configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_privilege.html for configuration guide."
#   type = list(object({
#     account_name = string # Account name. The forbidden value is:root,mysql.sys,tencentroot.
#     account_host = optional(string, "%") # Account host, default is `%`.

#     # Global privileges. Available values for Privileges:
#     #   SELECT, INSERT, UPDATE, DELETE, CREATE, PROCESS,
#     #   DROP, REFERENCES, INDEX, ALTER, SHOW DATABASES,
#     #   CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE,
#     #   CREATE VIEW, SHOW VIEW, CREATE ROUTINE,
#     #   ALTER ROUTINE, EVENT, TRIGGER, REPLICATION SLAVE,
#     #   REPLICATION CLIENT
#     global = set(string)

#     # Database privileges list. Privileges:
#     #   SELECT, INSERT, UPDATE, DELETE, CREATE,
#     #   DROP, REFERENCES, INDEX, ALTER,
#     #   CREATE TEMPORARY TABLES, LOCK TABLES,
#     #   EXECUTE, CREATE VIEW, SHOW VIEW,
#     #   CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER
#     database = optional(list(object({
#       database_name = string
#       privileges    = set(string)
#     })), [])

#     # Table privileges list. Privileges:
#     #   SELECT, INSERT, UPDATE, DELETE, CREATE,
#     #   DROP, REFERENCES, INDEX, ALTER,
#     #   CREATE VIEW, SHOW VIEW, TRIGGER
#     table = optional(list(object({
#       database_name = string
#       table_name    = string
#       privileges    = set(string)
#     })), [])

#     # Column privileges list. Privileges:
#     #   SELECT, INSERT, UPDATE, REFERENCES
#     column = optional(list(object({
#       database_name = string
#       table_name    = string
#       column_name   = string
#       privileges    = set(string)
#     })), [])
#   }))
#   default = []

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges : !contains(["root", "mysql.sys", "tencentroot"], privilege.account_name)
#     ])
#     error_message = "Invalid value for account_name. The following account names are forbidden: root, mysql.sys, tencentroot"
#   }

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges : length(privilege.global) > 0
#     ])
#     error_message = "Invalid configuration: global privileges must contain at least one privilege."
#   }

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges :
#       alltrue([
#         for g in privilege.global :
#         contains([
#           "SELECT",
#           "INSERT",
#           "UPDATE",
#           "DELETE",
#           "CREATE",
#           "PROCESS",
#           "DROP",
#           "REFERENCES",
#           "INDEX",
#           "ALTER",
#           "SHOW DATABASES",
#           "CREATE TEMPORARY TABLES",
#           "LOCK TABLES",
#           "EXECUTE",
#           "CREATE VIEW",
#           "SHOW VIEW",
#           "CREATE ROUTINE",
#           "ALTER ROUTINE",
#           "EVENT",
#           "TRIGGER",
#           "REPLICATION SLAVE",
#           "REPLICATION CLIENT"
#         ], g)
#       ])
#     ])
#     error_message = "Invalid value in global privileges."
#   }

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges :
#       alltrue([
#         for db in privilege.database :
#         alltrue([
#           for p in db.privileges :
#           contains([
#             "SELECT",
#             "INSERT",
#             "UPDATE",
#             "DELETE",
#             "CREATE",
#             "DROP",
#             "REFERENCES",
#             "INDEX",
#             "ALTER",
#             "CREATE TEMPORARY TABLES",
#             "LOCK TABLES",
#             "EXECUTE",
#             "CREATE VIEW",
#             "SHOW VIEW",
#             "CREATE ROUTINE",
#             "ALTER ROUTINE",
#             "EVENT",
#             "TRIGGER"
#           ], p)
#         ])
#       ])
#     ])
#     error_message = "Invalid value in database privileges."
#   }

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges :
#       alltrue([
#         for tb in privilege.table :
#         alltrue([
#           for p in tb.privileges :
#           contains([
#             "SELECT",
#             "INSERT",
#             "UPDATE",
#             "DELETE",
#             "CREATE",
#             "DROP",
#             "REFERENCES",
#             "INDEX",
#             "ALTER",
#             "CREATE VIEW",
#             "SHOW VIEW",
#             "TRIGGER"
#           ], p)
#         ])
#       ])
#     ])
#     error_message = "Invalid value in table privileges."
#   }

#   validation {
#     condition = alltrue([
#       for privilege in var.mysql_privileges :
#       alltrue([
#         for col in privilege.column :
#         alltrue([
#           for p in col.privileges :
#           contains([
#             "SELECT",
#             "INSERT",
#             "UPDATE",
#             "REFERENCES"
#           ], p)
#         ])
#       ])
#     ])
#     error_message = "Invalid value in column privileges."
#   }
# }