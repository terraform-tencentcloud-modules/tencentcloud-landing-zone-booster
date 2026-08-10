##################################################
# resource: tencentcloud_mysql_instance
##################################################
variable "instance_id" {
  description = "The id of a mysql instance."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "The name of a mysql instance."
  type        = string
  default     = ""
}

variable "mem_size" {
  description = "Memory size (in MB)."
  type        = number
  default     = 1000
}

variable "volume_size" {
  description = "Disk size (in GB)."
  type        = number
  default     = 200
}

variable "cpu_count" {
  description = "Cpu cores."
  type        = number
  default     = 2
}

variable "device_type" {
  description = "Device type."
  type        = string
  default     = "UNIVERSAL"
}

variable "tags" {
  description = "Instance tags."
  type        = map(string)
  default     = {}
}

variable "engine_version" {
  description = "The version number of the database engine to use. Supported versions include 5.5/5.6/5.7, and default is 5.7."
  type        = string
  default     = "5.7"
}

variable "root_password" {
  description = "Password of root account. This parameter can be specified when you purchase master instances, but it should be ignored when you purchase read-only instances or disaster recovery instances."
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "Indicates which availability zone will be used."
  type        = string
  default     = "ap-guangzhou-2"
}

variable "project_id" {
  description = "Project ID, default value is 0."
  type        = number
  default     = 0
}

variable "security_groups" {
  description = "Security groups to use."
  type        = list(string)
  default     = []
}

variable "parameters" {
  description = "List of parameters to use."
  type        = map(string)
  default     = {}
}

# MySQL instance net configuration
variable "internet_service" {
  description = "Indicates whether to enable the access to an instance from public network: 0 - No, 1 - Yes."
  type        = number
  default     = 0
}

variable "intranet_port" {
  description = "Public access port, rang form 1024 to 65535 and default value is 3306."
  type        = number
  default     = 3306
}

variable "vpc_id" {
  description = "ID of VPC, which can be modified once every 24 hours and can't be removed."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Private network ID. If vpc_id is set, this value is required."
  type        = string
  default     = ""
}

# MySQL instance payment configuration
variable "charge_type" {
  description = "Pay type of instance, valid values are PREPAID, POSTPAID. Default is POSTPAID."
  type        = string
  default     = "POSTPAID"
}

variable "prepaid_period" {
  description = "Period of instance. NOTES: Only supported prepaid instance."
  default     = 1
}

variable "auto_renew_flag" {
  description = "Auto renew flag. NOTES: Only supported prepaid instance."
  type        = number
  default     = 0
}

variable "force_delete" {
  description = "Indicate whether to delete instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance. When the main mysql instance set true, this para of the readonly mysql instance will not take effect."
  type        = bool
  default     = false
}

# MySQL instance slave configuration
variable "first_slave_zone" {
  description = "Zone information about first slave instance."
  type        = string
  default     = ""
}

variable "second_slave_zone" {
  description = "Zone information about second slave instance."
  type        = string
  default     = ""
}

variable "slave_deploy_mode" {
  description = "Availability zone deployment method. Available values: 0 - Single availability zone; 1 - Multiple availability zones."
  type        = number
  default     = 0
}

variable "slave_sync_mode" {
  description = "Data replication mode. 0 - Async replication; 1 - Semisync replication; 2 - Strongsync replication."
  type        = number
  default     = 0
}

##################################################
# resource: tencentcloud_mysql_readonly_instance
##################################################
variable "readonly_instances" {
  description = "Multiple readonly instances.Every element of the list contains a tencentcloud_mysql_readonly_instance configuration object.See https://www.terraform.io/docs/providers/tencentcloud/r/mysql_readonly_instance.html for configuration guide."
  type        = list(object({
    master_instance_id = string # Indicates the master instance ID of recovery instances.
    instance_name      = string
    cpu_count          = number
    mem_size           = number
    volume_size        = number
    device_type        = optional(string, "UNIVERSAL")
    intranet_port      = optional(number, 3306)
    charge_type        = optional(string, "POSTPAID")
    prepaid_period     = optional(number)
    security_groups    = optional(list(string))
    master_region      = optional(string)
    zone               = optional(string)
    vpc_id             = optional(string)
    subnet_id          = optional(string)
    slave_deploy_mode  = optional(number)
    ro_group_id        = optional(string)
    auto_renew_flag    = optional(number)
    force_delete       = optional(bool)
    tags               = optional(map(string))
  }))
  default = []
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