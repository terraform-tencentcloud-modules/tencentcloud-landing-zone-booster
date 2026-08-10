################################################################################
# data: tencentcloud_instance_types and tencentcloud_images
################################################################################
variable "exclude_sold_out" {
  type        = bool
  description = "Indicate to filter instances types that is sold out or not, default is false."
  default     = false
}

variable "cpu_core_count" {
  type        = number
  description = "The number of CPU cores of the instance."
  default     = 2
}

variable "memory_size" {
  type        = number
  description = "Instance memory capacity, unit in GB."
  default     = 2
}

variable "image_os_name" {
  description = "A string to apply with fuzzy match to the os_name attribute on the image list returned by TencentCloud, conflict with 'image_name_regex'."
  type        = string
  default     = null
}

################################################################################
# resource: tencentcloud_instance
################################################################################
# base config
variable "project_id" {
  type        = number
  description = "project id."
  default     = 0
}

#cvm
variable "instance_name" {
  description = "the name of instance to create."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The available zone for the instance.  "
  type        = string
  default     = null
}

variable "image_id" {
  description = "The image to use for the instance. Changing image_id will cause the instance reset."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "instance type of instance."
  type        = string
  default     = null
}

variable "host_name" {
  description = "The hostname of the instance. Windows instance: The name should be a combination of 2 to 15 characters comprised of letters (case insensitive), numbers, and hyphens (-). Period (.) is not supported, and the name cannot be a string of pure numbers. Other types (such as Linux) of instances: The name should be a combination of 2 to 60 characters, supporting multiple periods (.). The piece between two periods is composed of letters (case insensitive), numbers, and hyphens (-). Changing the `hostname` will cause the instance system to restart."
  type        = string
  default     = null
}

# storage
variable "system_disk_id" {
  description = "System disk snapshot ID used to initialize the system disk. When system disk type is `LOCAL_BASIC` and `LOCAL_SSD`, disk id is not supported."
  type        = string
  default     = null
}

variable "system_disk_name" {
  description = "Name of the system disk."
  type        = string
  default     = null
}

variable "system_disk_type" {
  description = "System disk type. For more information on limits of system disk types, see Storage Overview. Valid values: LOCAL_BASIC: local disk, LOCAL_SSD: local SSD disk, CLOUD_SSD: SSD, CLOUD_PREMIUM: Premium Cloud"
  type        = string
  default     = "CLOUD_PREMIUM"

  validation {
    condition     = contains(["LOCAL_BASIC", "LOCAL_SSD", "CLOUD_BASIC", "CLOUD_SSD", "CLOUD_PREMIUM", "CLOUD_BSSD", "CLOUD_HSSD", "CLOUD_TSSD"], var.system_disk_type)
    error_message = "Invalid value for system_disk_type."
  }
}

variable "system_disk_size" {
  type        = number
  description = "Size of the system disk. unit is GB, Default is 50GB. If modified, the instance may force stop."
  default     = 50
}

variable "system_disk_resize_online" {
  type        = bool
  description = "Resize online."
  default     = null
}

variable "data_disks" {
  description = "Settings for data disks."
  type = list(object({
    data_disk_type               = string
    data_disk_size               = number
    data_disk_name               = optional(string, null)
    data_disk_snapshot_id        = optional(string, null)
    data_disk_id                 = optional(string, null)
    delete_with_instance         = optional(bool, true)
    delete_with_instance_prepaid = optional(bool, false)
    kms_key_id                   = optional(string, null)
    encrypt                      = optional(bool, false)
    throughput_performance       = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for disk in var.data_disks : contains([
        "LOCAL_BASIC", "LOCAL_SSD", "LOCAL_NVME", "LOCAL_PRO", "CLOUD_BASIC", "CLOUD_PREMIUM", "CLOUD_SSD", "CLOUD_HSSD", "CLOUD_TSSD", "CLOUD_BSSD"
      ], disk.data_disk_type)
    ])
    error_message = "Invalid value for data_disk_type."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks : disk.data_disk_size > 0
    ])
    error_message = "Invalid value for data_disk_size. The data disk size must be greater than 0 GB."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks : disk.throughput_performance >= 0
    ])
    error_message = "Invalid value for throughput_performance. The value must be greater than or equal to 0."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks :
        disk.throughput_performance == 0 || contains(["CLOUD_TSSD", "CLOUD_HSSD"], disk.data_disk_type)
    ])
    error_message = "Invalid configuration: throughput_performance only works when data_disk_type is CLOUD_TSSD or CLOUD_HSSD."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks : !disk.encrypt || disk.kms_key_id != null
    ])
    error_message = "Invalid configuration: kms_key_id must be set when encrypt is true."
  }
}

# vpc config
variable "vpc_id" {
  description = "The ID of a VPC network. If you want to create instances in a VPC network, this parameter must be set or the default vpc will be used."
  type        = string
  default     = null
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The ID of a VPC subnet. If you want to create instances in a VPC network, this parameter must be set or the default subnet will be used."
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC, private IP must be an IP within the subnet specified by subnet_id。"
  type        = string
  default     = null
}

# security groups
variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "A list of orderly security group IDs to associate with."
}

# network config
variable "allocate_public_ip" {
  description = "Associate a public IP address with an instance in a VPC or Classic. Boolean value, Default is false."
  default     = false
  type        = bool
}

variable "internet_charge_type" {
  description = "Internet charge type of the instance, Valid values are `BANDWIDTH_PREPAID`, `TRAFFIC_POSTPAID_BY_HOUR`, `BANDWIDTH_POSTPAID_BY_HOUR` and `BANDWIDTH_PACKAGE`. If not set, internet charge type are consistent with the cvm charge type by default. This value takes NO Effect when changing and does not need to be set when `allocate_public_ip` is false."
  type        = string
  default     = null

  validation {
    condition     = var.internet_charge_type == null || contains(["BANDWIDTH_PREPAID", "BANDWIDTH_POSTPAID_BY_HOUR", "BANDWIDTH_PACKAGE", "TRAFFIC_POSTPAID_BY_HOUR"], var.internet_charge_type)
    error_message = "Invalid value for internet_charge_type."
  }
}

variable "bandwidth_package_id" {
  description = "bandwidth package id. if user is standard user, then the bandwidth_package_id is needed, or default has bandwidth_package_id."
  type        = string
  default     = null
}

variable "internet_max_bandwidth_out" {
  type        = number
  default     = 10
  description = "Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bits per second). This value does not need to be set when allocate_public_ip is false."
}

variable "ipv4_address_type" {
  description = "AddressType. Default value: WanIP. For beta users of dedicated IP. the value can be: HighQualityEIP: Dedicated IP. Note that dedicated IPs are only available in partial regions. For beta users of Anti-DDoS IP, the value can be: AntiDDoSEIP: Anti-DDoS EIP. Note that Anti-DDoS IPs are only available in partial regions."
  type        = string
  default     = null

  validation {
    condition     = var.ipv4_address_type == null || contains(["WanIP", "HighQualityEIP", "AntiDDoSEIP"], var.ipv4_address_type)
    error_message = "Invalid value for ipv4_address_type."
  }
}

variable "ipv6_address_type" {
  description = "IPv6 AddressType. Default value: WanIP. EIPv6: Elastic IPv6; HighQualityEIPv6: Premium IPv6, only China Hong Kong supports premium IPv6. To allocate IPv6 addresses to resources, please specify the Elastic IPv6 type."
  type        = string
  default     = null

  validation {
    condition     = var.ipv6_address_type == null || contains(["EIPv6", "HighQualityEIPv6"], var.ipv6_address_type)
    error_message = "Invalid value for ipv6_address_type."
  }
}

variable "ipv6_address_count" {
  type        = number
  default     = null
  description = "Specify the number of randomly generated IPv6 addresses for the Elastic Network Interface."
}

variable "anti_ddos_package_id" {
  type        = string
  default     = null
  description = "Anti-DDoS service package ID. This is required when you want to request an AntiDDoS IP."
}

# enhance services
variable "enable_security_service" {
  description = "Disable enhance service for security, it is enabled by default. When this options is set, security agent won't be installed. Modifications may lead to the reinstallation of the instance's operating system."
  type        = bool
  default     = true
}

variable "enable_monitor_service" {
  description = "Disable enhance service for monitor, it is enabled by default. When this options is set, monitor agent won't be installed. Modifications may lead to the reinstallation of the instance's operating system."
  type        = bool
  default     = true
}

variable "enable_automation_service" {
  description = "Disable enhance service for automation, it is enabled by default. When this options is set, monitor agent won't be installed. Modifications may lead to the reinstallation of the instance's operating system."
  type        = bool
  default     = true
}

# login config
variable "key_ids" {
  description = "The key pair to use for the instance, it looks like `skey-16jig7tx`. Modifications may lead to the reinstallation of the instance's operating system."
  type        = list(string)
  default     = null
}

variable "password" {
  description = "Login password of the instance. For Linux instances, the password must include 8-30 characters, and contain at least two of the following character sets: [a-z], [A-Z], [0-9] and [()`~!@#$%^&*-+="
  type        = string
  default     = null
}

variable "keep_image_login" {
  description = "Whether to keep image login or not, default is `false`. When the image type is private or shared or imported, this parameter can be set `true`. Modifications may lead to the reinstallation of the instance's operating system."
  type        = bool
  default     = null
}

variable "user_data" {
  description = "Can be used instead of user_data_raw to pass base64-encoded binary data directly. Use this instead of user_data_raw whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "user_data_raw" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Whether to keep image login or not, default is `false`. When the image type is private or shared or imported, this parameter can be set `true`. Modifications may lead to the reinstallation of the instance's operating system."
  type        = bool
  default     = false
}

# role config
variable "cam_role_name" {
  description = "CAM role name authorized to access."
  type        = string
  default     = null
}

# hpc cluster config
variable "hpc_cluster_id" {
  description = "High-performance computing cluster ID. If the instance created is a high-performance computing instance, you need to specify the cluster in which the instance is placed, otherwise it cannot be specified."
  type        = string
  default     = null
}

# payment config
variable "instance_charge_type" {
  description = "The charge type of instance. Valid values are `PREPAID`, `POSTPAID_BY_HOUR`, `SPOTPAID`, `CDHPAID` and `CDCPAID`. The default is `POSTPAID_BY_HOUR`. Note: TencentCloud International only supports `POSTPAID_BY_HOUR` and `CDHPAID`. `PREPAID` instance may not allow to delete before expired. `SPOTPAID` instance must set `spot_instance_type` and `spot_max_price` at the same time. `CDHPAID` instance must set `cdh_instance_type` and `cdh_host_id`."
  type        = string
  default     = "POSTPAID_BY_HOUR"

  validation {
    condition     = contains(["PREPAID", "POSTPAID_BY_HOUR", "SPOTPAID", "CDHPAID", "CDCPAID", "UNDERWRITE"], var.instance_charge_type)
    error_message = "Invalid value for instance_charge_type. Valid values are: PREPAID, POSTPAID_BY_HOUR, SPOTPAID, CDHPAID, CDCPAID,UNDERWRITE."
  }
}

variable "instance_charge_type_prepaid_period" {
  description = "The tenancy (time unit is month) of the prepaid instance, NOTE: it only works when instance_charge_type is set to `PREPAID`. Valid values are `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `24`, `36`, `48`, `60`."
  type        = string
  default     = "1"

  validation {
    condition     = contains(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "24", "36", "48", "60"], var.instance_charge_type_prepaid_period)
    error_message = "Invalid value for instance_charge_type_prepaid_period."
  }
}

variable "instance_charge_type_prepaid_renew_flag" {
  description = "Auto renewal flag. Valid values: `NOTIFY_AND_AUTO_RENEW`: notify upon expiration and renew automatically, `NOTIFY_AND_MANUAL_RENEW`: notify upon expiration but do not renew automatically, `DISABLE_NOTIFY_AND_MANUAL_RENEW`: neither notify upon expiration nor renew automatically. Default value: `NOTIFY_AND_MANUAL_RENEW`. If this parameter is specified as `NOTIFY_AND_AUTO_RENEW`, the instance will be automatically renewed on a monthly basis if the account balance is sufficient. NOTE: it only works when instance_charge_type is set to `PREPAID`."
  type        = string
  default     = "NOTIFY_AND_MANUAL_RENEW"

  validation {
    condition     = contains(["NOTIFY_AND_AUTO_RENEW", "NOTIFY_AND_MANUAL_RENEW", "DISABLE_NOTIFY_AND_MANUAL_RENEW"], var.instance_charge_type_prepaid_renew_flag)
    error_message = "Invalid value for instance_charge_type_prepaid_renew_flag."
  }
}

variable "spot_instance_type" {
  description = "Type of spot instance, only support `ONE-TIME` now. Note: it only works when instance_charge_type is set to `SPOTPAID`."
  type        = string
  default     = null

  validation {
    condition     = var.spot_instance_type == null || contains(["ONE-TIME"], var.spot_instance_type)
    error_message = "Invalid value for spot_instance_type."
  }
}

variable "spot_max_price" {
  description = "Max price of a spot instance, is the format of decimal string, for example \"0.50\". Note: it only works when instance_charge_type is set to `SPOTPAID`."
  type        = string
  default     = null
}

variable "cdh_instance_type" {
  description = "Type of instance created on cdh, the value of this parameter is in the format of CDH_XCXG based on the number of CPU cores and memory capacity. Note: it only works when instance_charge_type is set to CDHPAID."
  type        = string
  default     = null

  validation {
    condition     = var.cdh_instance_type == null || startswith(var.cdh_instance_type, "CDH_")
    error_message = "Invalid value for cdh_instance_type. The value must start with 'CDH_', for example: CDH_2C4G, CDH_4C8G, CDH_8C16G."
  }
}

variable "cdh_host_id" {
  description = "Id of cdh instance. Note: it only works when instance_charge_type is set to CDHPAID."
  type        = string
  default     = null
}

# disaster recover group
variable "disaster_recover_group_ids" {
  description = "Disaster ecover group IDs."
  type        = list
  default     = null
}

# stop config
variable "stop_type" {
  description = "Instance shutdown mode. Valid values: SOFT_FIRST: perform a soft shutdown first, and force shut down the instance if the soft shutdown fails; HARD: force shut down the instance directly; SOFT: soft shutdown only. Default value: SOFT."
  type        = string
  default     = "SOFT"

  validation {
    condition     = contains(["SOFT_FIRST", "HARD", "SOFT"], var.stop_type)
    error_message = "Invalid value for stop_type. Valid values are: SOFT_FIRST, HARD, SOFT. Default value is SOFT."
  }
}

variable "stopped_mode" {
  description = "Billing method of a pay-as-you-go instance after shutdown. Available values: `KEEP_CHARGING`,`STOP_CHARGING`. Default `KEEP_CHARGING`."
  type        = string
  default     = "KEEP_CHARGING"

  validation {
    condition     = contains(["KEEP_CHARGING", "STOP_CHARGING"], var.stopped_mode)
    error_message = "Invalid value for stopped_mode. Valid values are: KEEP_CHARGING, STOP_CHARGING. Default value is KEEP_CHARGING."
  }
}

# delete config
variable "force_delete" {
  description = "Indicate whether to force delete the instance. Default is `false`. If set true, the instance will be permanently deleted instead of being moved into the recycle bin. Note: only works for `PREPAID` instance."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Whether the termination protection is enabled. Default is `false`. If set true, which means that this instance can not be deleted by an API action."
  type        = bool
  default     = false
}

# placement group
variable "placement_group_id" {
  description = "The Placement Group Id to start the instance in, see tencentcloud_placement_group."
  type        = string
  default     = null
}

variable "placement_group_name" {
  description = "The Placement group name to start the instance in, see tencentcloud_placement_group. will ignore if placement_group_id passed."
  type        = string
  default     = null
}

variable "placement_group_type" {
  description = "Type of the placement group. Valid values: HOST, SW and RACK."
  type        = string
  default     = null

  validation {
    condition     = var.placement_group_type == null || contains(["HOST", "SW", "RACK"], var.placement_group_type)
    error_message = "Invalid value for placement_group_type. Valid values are: HOST, SW, RACK."
  }
}

variable "force_replace_placement_group_id" {
  description = "Whether to force the instance host to be replaced. Value range: true: Allows the instance to change the host and restart the instance. Local disk machines do not support specifying this parameter; false: Does not allow the instance to change the host and only join the placement group on the current host. This may cause the placement group to fail to change. Only useful for change `placement_group_id`, Default is false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

################################################################################
# resource: tencentcloud_cbs_storage
################################################################################
variable "cbs_block_devices" {
  description = "Additional CBS block devices to attach to the instance. see resource tencentcloud_cbs_storage."
  type = list(object({
    project_id        = optional(number, 0) # ID of the project to which the instance belongs. Default is 0.
    storage_name      = string # Name of CBS. The length must be between 2 and 60 bytes.
    storage_type      = string # Type of CBS medium. Valid values: CLOUD_BASIC, CLOUD_PREMIUM, CLOUD_BSSD, CLOUD_SSD, CLOUD_HSSD, CLOUD_TSSD.
    storage_size      = number # Volume of CBS, unit is GB.
    availability_zone = string # The available zone that the CBS instance locates at.

    # payment
    charge_type        = optional(string, "POSTPAID_BY_HOUR") # The charge type of CBS instance. Valid values: PREPAID, POSTPAID_BY_HOUR, CDCPAID, DEDICATED_CLUSTER_PAID. Default is POSTPAID_BY_HOUR.
    prepaid_period     = optional(number, null) # The tenancy (month) of the prepaid instance. Only works when charge_type is PREPAID. Valid values: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36.
    prepaid_renew_flag = optional(string, "NOTIFY_AND_MANUAL_RENEW") # Auto Renewal flag. Valid values: NOTIFY_AND_AUTO_RENEW, NOTIFY_AND_MANUAL_RENEW, DISABLE_NOTIFY_AND_MANUAL_RENEW. Only works when charge_type is PREPAID.
 
    # optional
    dedicated_cluster_id   = optional(string) # Exclusive cluster id. Only works when charge_type is CDCPAID or DEDICATED_CLUSTER_PAID.
    snapshot_id            = optional(string) # ID of the snapshot. If specified, created the CBS by this snapshot.
    throughput_performance = optional(number) # Add extra performance to the data disk. Only works when disk type is CLOUD_TSSD or CLOUD_HSSD.
    disk_backup_quota      = optional(number) # The quota of backup points of cloud disk.
    burst_performance      = optional(bool)   # Whether to enable performance burst when creating a cloud disk.

    # data encrypt
    encrypt      = optional(bool, false) # Pass in this parameter to create an encrypted cloud disk.
    kms_key_id   = optional(string)      # When purchasing an encryption disk, customize the key. Must be set when encrypt is true.
    encrypt_type = optional(string)      # Specifies the cloud disk encryption type. Valid values: ENCRYPT_V1, ENCRYPT_V2. Only valid when creating an encrypted cloud disk. 
    
    # others
    force_delete = optional(bool, false) # Indicate whether to delete CBS instance directly or not. Default is false.
    tags         = optional(map(string), {}) # The available tags within this CBS.
  }))
  default = []

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices :
        contains(["CLOUD_BASIC", "CLOUD_PREMIUM", "CLOUD_BSSD", "CLOUD_SSD", "CLOUD_HSSD", "CLOUD_TSSD"], cbs.storage_type)
    ])
    error_message = "Invalid value for storage_type."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.storage_size > 0
    ])
    error_message = "Invalid value for storage_size. The storage size must be greater than 0 GB."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : length(cbs.storage_name) >= 2 && length(cbs.storage_name) <= 60
    ])
    error_message = "Invalid value for storage_name. The name length must be between 2 and 60 characters."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices :
        contains(["PREPAID", "POSTPAID_BY_HOUR", "CDCPAID", "DEDICATED_CLUSTER_PAID"], cbs.charge_type)
    ])
    error_message = "Invalid value for charge_type."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices :
        cbs.prepaid_period == null || contains([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36], cbs.prepaid_period)
    ])
    error_message = "Invalid value for prepaid_period. Valid values are: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.prepaid_period == null || cbs.charge_type == "PREPAID"
    ])
    error_message = "Invalid configuration: prepaid_period only works when charge_type is set to PREPAID."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices :
      cbs.prepaid_renew_flag == null || contains(["NOTIFY_AND_AUTO_RENEW", "NOTIFY_AND_MANUAL_RENEW", "DISABLE_NOTIFY_AND_MANUAL_RENEW"], cbs.prepaid_renew_flag)
    ])
    error_message = "Invalid value for prepaid_renew_flag."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.prepaid_renew_flag == null || cbs.charge_type == "PREPAID"
    ])
    error_message = "Invalid configuration: prepaid_renew_flag only works when charge_type is set to PREPAID."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.throughput_performance == 0 || contains(["CLOUD_TSSD", "CLOUD_HSSD"], cbs.storage_type)
    ])
    error_message = "Invalid configuration: throughput_performance only works when storage_type is CLOUD_TSSD or CLOUD_HSSD."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : !cbs.encrypt || cbs.kms_key_id != null
    ])
    error_message = "Invalid configuration: kms_key_id must be set when encrypt is true."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.encrypt_type == null || contains(["ENCRYPT_V1", "ENCRYPT_V2"], cbs.encrypt_type)
    ])
    error_message = "Invalid value for encrypt_type. Valid values are: ENCRYPT_V1 (first-generation), ENCRYPT_V2 (second-generation, recommended)."
  }

  validation {
    condition = alltrue([
      for cbs in var.cbs_block_devices : cbs.encrypt_type == null || cbs.encrypt == true
    ])
    error_message = "Invalid configuration: encrypt_type is only valid when encrypt is set to true."
  }
}

variable "cbs_block_device_ids" {
  description = "Attach exist CBS block devices to the instance by id.  see resource tencentcloud_cbs_storage."
  type        = list(string)
  default     = []
}

variable "cbs_tags" {
  description = "Additional tags to assign to cbs resource."
  type        = map(string)
  default     = {}
}

################################################################################
# resource: tencentcloud_eni_attachment
################################################################################
variable "eni_ids" {
  description = "A list of eni_id to bind with the instance. see resource tencentcloud_eni."
  type        = list(string)
  default     = []
}
