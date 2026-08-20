variable "cluster_id" {
  type        = string
  description = "existing cluster id, used when create_cluster is false"
}

variable "native_node_pools" {
  description = "Map of native node pool definitions to create. see `tencentcloud_kubernetes_native_node_pool`"
  type = list(object({
    name                = string # Node pool name.
    deletion_protection = optional(bool) # Whether to enable deletion protection.
    unschedulable       = optional(bool) # Whether the node is not schedulable by default. The native node is not aware of it and passes false by default.

    # -------------------------
    # Node Labels.
    # -------------------------
    labels = optional(list(object({
      name  = string # Name in the map table.
      value = string # Value in map table.
    })), [])

    # -------------------------
    # Node taint.
    # -------------------------
    taints = optional(list(object({
      key    = optional(string) # Key of the taint.
      value  = optional(string) # Value of the taint.
      effect = optional(string) # Effect values: NoSchedule, PreferNoSchedule, NoExecute
    })), [])

    # -------------------------
    # Node tags.
    # -------------------------
    tags = optional(list(object({
      resource_type = optional(string) # The resource type bound to the label. `cluster`: related to clusters; `machine`: related to node pools.
      tags = optional(list(object({
        key   = optional(string) # Tag key.
        value = optional(string) # Tag value.
      })), [])
    })), [])

    # -------------------------
    # Node Annotations
    # -------------------------
    annotations = optional(list(object({
      name  = string # Name in the map table.
      value = string # Value in the map table.
    })), [])

    # -------------------------
    # Native Configuration
    # -------------------------
    subnet_ids               = list(string) # Subnet list.
    instance_types           = list(string) # Model list.
    security_group_ids       = list(string) # Security group list.
    instance_charge_type     = optional(string, "POSTPAID_BY_HOUR") # Node billing type. `PREPAID` is a yearly and monthly subscription, `POSTPAID_BY_HOUR` is a pay-as-you-go plan. The default is `POSTPAID_BY_HOUR`.
    machine_type             = optional(string, "Native") # Node pool type. Example value: `NativeCVM` or `Native`. Default is `Native`.
    auto_repair              = optional(bool) # Whether to enable self-healing ability.
    enable_autoscaling       = optional(bool) # Whether to enable elastic scaling.
    replicas                 = optional(number) # Desired number of nodes.
    health_check_policy_name = optional(string) # Fault self-healing rule name.
    host_name_pattern        = optional(string) # Native node pool hostName pattern string.
    kubelet_args             = optional(list(string)) # Kubelet custom parameters.
    runtime_root_dir         = optional(string) # Runtime root directory.
    key_ids                  = optional(list(string)) # Node pool ssh public key id array.

    # ---------------------
    # Native Scaling Configuration
    # ---------------------
    scaling = optional(object({
      min_replicas  = optional(number) # Minimum number of replicas in node pool.
      max_replicas  = optional(number) # Maximum number of replicas in node pool.
      create_policy = optional(string) # Node pool expansion strategy. `ZoneEquality`: multiple availability zones are broken up; `ZonePriority`: the preferred availability zone takes precedence.
    }), null)

    # ---------------------
    # Native System Disk Configuration
    # ---------------------
    system_disk = object({
      disk_type  = string # Cloud disk type. `CLOUD_PREMIUM`: Premium Cloud Storage, `CLOUD_SSD`: cloud SSD disk, `CLOUD_BSSD`: Basic SSD, `CLOUD_HSSD`: Enhanced SSD.
      disk_size  = number # Cloud disk size (G).
      #encrypt    = optional(string) # Encrypt System Drive. Allow value: `ENCRYPT`.
      #kms_key_id = optional(string) # Kms key ID.
    })

    # ---------------------
    # Native Billing Configuration for Yearly and Monthly Models
    # ---------------------
    instance_charge_prepaid = optional(object({
      period = number # Postpaid billing cycle, unit (month): 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36, 48, 60.
      # Prepaid renewal method:
      #   `NOTIFY_AND_AUTO_RENEW`         : Notify users of expiration and automatically renew (default).
      #   `NOTIFY_AND_MANUAL_RENEW`       : Notify users of expiration, but do not automatically renew.
      #   `DISABLE_NOTIFY_AND_MANUAL_RENEW`: Do not notify users of expiration and do not automatically renew.
      renew_flag = optional(string)
    }), null)

    # ---------------------
    # Native Management Parameter Settings
    # ---------------------
    management = optional(object({
      nameservers = optional(list(string)) # Dns configuration.
      hosts       = optional(list(string)) # Hosts configuration.
      kernel_args = optional(list(string)) # Kernel parameter configuration.
    }), null)

    # ---------------------
    # Native Predefined Scripts
    # ---------------------
    lifecycle = optional(object({
      pre_init  = optional(string) # Custom script before node initialization.
      post_init = optional(string) # Custom script after node initialization.
    }), null)

    # ---------------------
    # Native Public Network Bandwidth Settings
    # ---------------------
    # charge_type:
    #   Optional value is `TRAFFIC_POSTPAID_BY_HOUR`, `BANDWIDTH_POSTPAID_BY_HOUR` and `BANDWIDTH_PACKAGE`.
    # max_bandwidth_out:
    #   Note: When chargeType is `TRAFFIC_POSTPAID_BY_HOUR` and `BANDWIDTH_POSTPAID_BY_HOUR`, the valid range is 1~100.
    #         When chargeType is `BANDWIDTH_PACKAG`, the valid range is 1~2000.
    # bandwidth_package_id:
    #   Note: When ChargeType is BANDWIDTH_PACKAGE, the value cannot be empty; otherwise, the value must be empty.
    internet_accessible = optional(object({
      charge_type          = string # Network billing method.
      max_bandwidth_out    = number # Maximum bandwidth output.
      bandwidth_package_id = optional(string) # Bandwidth package ID.
    }), null)

    # ---------------------
    # Native Node Pool Data Disk List
    # ---------------------
    # disk_type: Cloud disk type.
    # Valid values:
    #   `CLOUD_PREMIUM`: Premium Cloud Storage,
    #   `CLOUD_SSD`    : cloud SSD disk,
    #   `CLOUD_BSSD`   : Basic SSD,
    #   `CLOUD_HSSD`   : Enhanced SSD,
    #   `CLOUD_TSSD`   : Tremendous SSD,
    #   `LOCAL_NVME`   : local NVME disk.
    # file_system: File system (ext3/ext4/xfs).
    # disk_size:   Cloud disk size (G).
    # Whether to automatically format the disk and mount it.
    # Mount device name or partition name.
    # Mount directory.
    # Pass in this parameter to create an encrypted cloud disk. The value is fixed to `ENCRYPT`.
    # Customize the key when purchasing an encrypted disk.
    # When this parameter is passed in, the Encrypt parameter is not empty.
    # Snapshot ID. If passed in, the cloud disk will be created based on this snapshot.
    # The snapshot type must be a data disk snapshot.
    # Cloud disk performance, unit: MB/s.
    # Use this parameter to purchase additional performance for the cloud disk.
    data_disks = optional(list(object({
      disk_type              = string
      disk_size              = number
      auto_format_and_mount  = bool
      file_system            = optional(string)
      disk_partition         = optional(string)
      mount_target           = optional(string)
      encrypt                = optional(string)
      kms_key_id             = optional(string)
      snapshot_id            = optional(string)
      throughput_performance = optional(number)
    })), [])
  }))
  default = []

  # -------------------------
  # taints.effect enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools : alltrue([
        for taint in pool.taints :taint.effect == null || contains([
          "NoSchedule",
          "PreferNoSchedule",
          "NoExecute"
        ], taint.effect)
      ])
    ])
    error_message = <<-EOT
      Invalid value for taints.effect. Valid values are:
        NoSchedule        : Do not schedule
        PreferNoSchedule  : Prefer not to schedule
        NoExecute         : Do not execute
    EOT
  }

  # -------------------------
  # instance_charge_type enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools : contains(["PREPAID", "POSTPAID_BY_HOUR"], pool.instance_charge_type)
    ])
    error_message = <<-EOT
      Invalid value for native.instance_charge_type. Valid values are:
        PREPAID          : Yearly and monthly subscription
        POSTPAID_BY_HOUR : Pay-as-you-go
    EOT
  }

  # -------------------------
  # system_disk.disk_type enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools : contains([
        "CLOUD_PREMIUM",
        "CLOUD_SSD",
        "CLOUD_BSSD",
        "CLOUD_HSSD"
      ], pool.system_disk.disk_type)
    ])
    error_message = <<-EOT
      Invalid value for native.system_disk.disk_type. Valid values are:
        CLOUD_PREMIUM : Premium Cloud Storage
        CLOUD_SSD     : Cloud SSD Disk
        CLOUD_BSSD    : Basic SSD Cloud Disk
        CLOUD_HSSD    : Enhanced SSD Cloud Disk
    EOT
  }

  # -------------------------
  # scaling.create_policy enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
        pool.scaling == null ||
        pool.scaling.create_policy == null ||
        contains(["ZoneEquality", "ZonePriority"], pool.scaling.create_policy)
    ])
    error_message = <<-EOT
      Invalid value for native.scaling.create_policy. Valid values are:
        ZoneEquality : Multiple availability zones are broken up
        ZonePriority : The preferred availability zone takes precedence
    EOT
  }

  # -------------------------
  # instance_charge_prepaid.period enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
        pool.instance_charge_prepaid == null ||
        contains([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36, 48, 60], pool.instance_charge_prepaid.period)
    ])
    error_message = <<-EOT
      Invalid value for native.instance_charge_prepaid.period. Valid values are:
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36, 48, 60 (months)
    EOT
  }

  # -------------------------
  # instance_charge_prepaid.renew_flag enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      pool.instance_charge_prepaid == null ||
      pool.instance_charge_prepaid.renew_flag == null ||
      contains([
        "NOTIFY_AND_AUTO_RENEW",
        "NOTIFY_AND_MANUAL_RENEW",
        "DISABLE_NOTIFY_AND_MANUAL_RENEW"
      ], pool.instance_charge_prepaid.renew_flag)
    ])
    error_message = <<-EOT
      Invalid value for native.instance_charge_prepaid.renew_flag. Valid values are:
        NOTIFY_AND_AUTO_RENEW           : Notify and auto renew
        NOTIFY_AND_MANUAL_RENEW         : Notify but manual renew
        DISABLE_NOTIFY_AND_MANUAL_RENEW : No notify and manual renew
    EOT
  }

  # -------------------------
  # internet_accessible.charge_type enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      pool.internet_accessible == null ||
      contains([
        "TRAFFIC_POSTPAID_BY_HOUR",
        "BANDWIDTH_POSTPAID_BY_HOUR",
        "BANDWIDTH_PACKAGE"
      ], pool.internet_accessible.charge_type)
    ])
    error_message = <<-EOT
      Invalid value for native.internet_accessible.charge_type. Valid values are:
        TRAFFIC_POSTPAID_BY_HOUR   : Traffic postpaid by hour
        BANDWIDTH_POSTPAID_BY_HOUR : Bandwidth postpaid by hour
        BANDWIDTH_PACKAGE          : Bandwidth package
    EOT
  }

  # -------------------------
  # internet_accessible.max_bandwidth_out range validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      pool.internet_accessible == null ||
      pool.internet_accessible.max_bandwidth_out >= 1
    ])
    error_message = "Invalid value for native.internet_accessible.max_bandwidth_out. The value must be greater than or equal to 1."
  }

  # -------------------------
  # data_disks.disk_type enum validation
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      alltrue([
        for disk in pool.data_disks :
        contains([
          "CLOUD_PREMIUM",
          "CLOUD_SSD",
          "CLOUD_BSSD",
          "CLOUD_HSSD",
          "CLOUD_TSSD",
          "LOCAL_NVME"
        ], disk.disk_type)
      ])
    ])
    error_message = <<-EOT
      Invalid value for native.data_disks.disk_type. Valid values are:
        CLOUD_PREMIUM : Premium Cloud Storage
        CLOUD_SSD     : Cloud SSD Disk
        CLOUD_BSSD    : Basic SSD Cloud Disk
        CLOUD_HSSD    : Enhanced SSD Cloud Disk
        CLOUD_TSSD    : Tremendous SSD Cloud Disk
        LOCAL_NVME    : Local NVME Disk
    EOT
  }

  # -------------------------
  # PREPAID requires instance_charge_prepaid
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      pool.instance_charge_type != "PREPAID" ||
      pool.instance_charge_prepaid != null
    ])
    error_message = "Invalid configuration: native.instance_charge_prepaid must be set when instance_charge_type is PREPAID."
  }

  # -------------------------
  # BANDWIDTH_PACKAGE requires bandwidth_package_id
  # -------------------------
  validation {
    condition = alltrue([
      for pool in var.native_node_pools :
      pool.internet_accessible == null ||
      pool.internet_accessible.charge_type != "BANDWIDTH_PACKAGE" ||
      pool.internet_accessible.bandwidth_package_id != null
    ])
    error_message = "Invalid configuration: native.internet_accessible.bandwidth_package_id must be set when charge_type is BANDWIDTH_PACKAGE."
  }
}