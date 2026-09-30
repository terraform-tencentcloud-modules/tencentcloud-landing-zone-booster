################################################################################
# Zone list by product
################################################################################
variable "zone_query_product" {
  description = "Product name for which to query the zones."
  type        = string
  default     = "ckafka"
}

################################################################################
# CKafka Instance variables
################################################################################
variable "instances" {
  description = "A map of CKafka instances to create. The key is used as the instance identifier."
  type = map(object({
    instance_name            = string
    zone_name                = string
    multi_zone_flag          = optional(bool, false)
    zone_names               = optional(set(string))
    vpc_id                   = optional(string)
    subnet_id                = optional(string)
    charge_type              = optional(string, "PREPAID")    # PREPAID / POSTPAID_BY_HOUR
    period                   = optional(number)               # prepaid purchase time in months
    instance_type            = optional(number)               # description of instance type
    specifications_type      = optional(string, "profession") # standard / profession / premium
    upgrade_strategy         = optional(number, 1)            # POSTPAID_BY_HOUR scale-down mode: 1 stable, 2 high-speed
    kafka_version            = optional(string)               # 0.10.2 / 1.1.1 / 2.4.1
    disk_type                = optional(string)               # CLOUD_SSD / CLOUD_BASIC (profession only)
    disk_size                = optional(number)               # disk size (GB)
    band_width               = optional(number)               # instance bandwidth in MBps
    partition                = optional(number)               # partition size
    msg_retention_time       = optional(number)               # max retention time in minutes (default 10080 = 7d)
    renew_flag               = optional(number)               # 0 default, 1 auto renew, 2 no auto renew
    public_network           = optional(number)               # public network bandwidth
    max_message_byte         = optional(number)               # instance level single message size (1024 - 12582912)
    elastic_bandwidth_switch = optional(number)               # 0 off, 1 on
    custom_ssl_cert_id       = optional(string)               # custom certificate id (profession only)
    delete_protection_enable = optional(number)               # 1 enable, 0 disable
    tag_set                  = optional(map(string))          # instance tags

    config = optional(object({
      auto_create_topic_enable   = bool
      default_num_partitions     = number
      default_replication_factor = number
    }))

    dynamic_retention_config = optional(object({
      enable                  = optional(number)
      disk_quota_percentage   = optional(number)
      step_forward_percentage = optional(number)
      bottom_retention        = optional(number)
    }))
  }))
  default = {}
}

################################################################################
# CKafka Topic variables
################################################################################
variable "topics" {
  description = "A map of CKafka topics to create. Each topic references a CKafka instance (by the `instances` map key) via `instance_key`."
  type = map(object({
    instance_key                   = string
    topic_name                     = string
    partition_num                  = number
    replica_num                    = number
    enable_white_list              = optional(bool, false)
    ip_white_list                  = optional(list(string))
    note                           = optional(string)
    retention                      = optional(number, 60000) # message retention time in milliseconds
    sync_replica_min_num           = optional(number, 1)
    clean_up_policy                = optional(string, "delete") # delete / compact / compact,delete
    unclean_leader_election_enable = optional(bool, false)
    segment                        = optional(number) # segment rolling time in ms (min 3600000)
  }))
  default = {}
}

################################################################################
# CKafka Route (access point) variables
################################################################################
variable "routes" {
  description = "A map of CKafka VPC routes (access points) to create. Each route references a CKafka instance via `instance_key`."
  type = map(object({
    instance_key   = string
    vip_type       = number # 3: vpc routing; 4: standard support routing; 7: profession support routing
    vpc_id         = optional(string)
    subnet_id      = optional(string)
    access_type    = optional(number) # 0: PLAINTEXT, 1: SASL_PLAINTEXT, 2: SSL, 3: SASL_SSL
    auth_flag      = optional(number)
    caller_appid   = optional(number)
    public_network = optional(number)
    ip             = optional(string)
  }))
  default = {}
}

################################################################################
# CKafka User variables
################################################################################
variable "users" {
  description = "A map of CKafka users (accounts) to create. Each user references a CKafka instance via `instance_key`."
  type = map(object({
    instance_key = string
    account_name = string
    password     = string # sensitive
  }))
  default = {}
}

################################################################################
# CKafka ACL variables
################################################################################
variable "acls" {
  description = "A map of CKafka ACL rules to create. Each ACL references a CKafka instance via `instance_key`."
  type = map(object({
    instance_key    = string
    resource_type   = optional(string, "TOPIC") # UNKNOWN / ANY / TOPIC / GROUP / CLUSTER / TRANSACTIONAL_ID
    resource_name   = string
    operation_type  = string                    # UNKNOWN / ANY / ALL / READ / WRITE / CREATE / DELETE / ALTER / DESCRIBE / CLUSTER_ACTION / DESCRIBE_CONFIGS / ALTER_CONFIGS
    permission_type = optional(string, "ALLOW") # UNKNOWN / ANY / DENY / ALLOW
    host            = optional(string, "*")
    principal       = optional(string, "*")
  }))
  default = {}
}
