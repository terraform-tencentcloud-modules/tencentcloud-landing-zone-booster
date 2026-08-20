resource "tencentcloud_kubernetes_native_node_pool" "this" {
  for_each = { for node_pool in var.native_node_pools : node_pool.name => node_pool}

  cluster_id          = var.cluster_id
  name                = each.value.name
  type                = "Native"
  deletion_protection = each.value.deletion_protection
  unschedulable       = each.value.unschedulable

  native {
    subnet_ids               = each.value.subnet_ids
    instance_charge_type     = each.value.instance_charge_type
    instance_types           = each.value.instance_types
    security_group_ids       = each.value.security_group_ids
    auto_repair              = each.value.auto_repair
    host_name_pattern        = each.value.host_name_pattern
    kubelet_args             = each.value.kubelet_args
    runtime_root_dir         = each.value.runtime_root_dir
    enable_autoscaling       = each.value.enable_autoscaling
    replicas                 = each.value.replicas
    key_ids                  = each.value.key_ids
    machine_type             = each.value.machine_type
    health_check_policy_name = each.value.health_check_policy_name

    system_disk {
      disk_type  = each.value.system_disk.disk_type
      disk_size  = each.value.system_disk.disk_size
      #encrypt    = each.value.native.system_disk.encrypt
      #kms_key_id = each.value.native.system_disk.kms_key_id
    }

    dynamic data_disks {
      for_each = each.value.data_disks
      content {
        disk_type              = data_disks.value.disk_type
        file_system            = data_disks.value.file_system
        disk_size              = data_disks.value.disk_size
        mount_target           = data_disks.value.mount_target
        auto_format_and_mount  = data_disks.value.auto_format_and_mount
        disk_partition         = data_disks.value.disk_partition
        encrypt                = data_disks.value.encrypt
        kms_key_id             = data_disks.value.kms_key_id
        snapshot_id            = data_disks.value.snapshot_id
        throughput_performance = data_disks.value.throughput_performance
      }
    }

    dynamic "scaling" {
      for_each = each.value.scaling != null ? [each.value.scaling] : []
      content {
        min_replicas  = scaling.value.min_replicas
        max_replicas  = scaling.value.max_replicas
        create_policy = scaling.value.create_policy
      }
    }

    dynamic "internet_accessible" {
      for_each = each.value.internet_accessible != null ? [each.value.internet_accessible] : []
      content {
        charge_type          = internet_accessible.value.charge_type
        max_bandwidth_out    = internet_accessible.value.max_bandwidth_out
        bandwidth_package_id = internet_accessible.value.charge_type == "BANDWIDTH_PACKAGE" ? internet_accessible.value.bandwidth_package_id : null
      }
    }

    dynamic "instance_charge_prepaid" {
      for_each = each.value.instance_charge_type == "PREPAID" && each.value.instance_charge_prepaid != null ? [each.value.instance_charge_prepaid] : []
      content {
        period     = instance_charge_prepaid.value.period
        renew_flag = instance_charge_prepaid.value.renew_flag
      }
    }

    dynamic "management" {
      for_each = each.value.management != null ? [each.value.management] : []
      content {
        nameservers = management.value.nameservers
        hosts       = management.value.hosts
        kernel_args = management.value.kernel_args
      }
    }

    dynamic "lifecycle" {
      for_each = each.value.lifecycle != null ? [each.value.lifecycle] : []
      content {
        pre_init  = lifecycle.value.pre_init
        post_init = lifecycle.value.post_init
      }
    }
  }

  dynamic "taints" {
    for_each = each.value.taints
    content {
      key    = taints.value.key
      value  = taints.value.value
      effect = taints.value.effect
    }
  }

  dynamic annotations {
    for_each = each.value.annotations
    content {
      name  = annotations.value.name
      value = annotations.value.value
    }
  }

  dynamic "labels" {
    for_each = each.value.labels
    content {
      name  = labels.value.name
      value = labels.value.value
    }
  }

  dynamic "tags" {
    for_each = each.value.tags
    content {
      resource_type = tags.value.resource_type
      dynamic "tags" {
        for_each = tags.value.tags
        content {
          key   = tags.value.key
          value = tags.value.value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      native[0].replicas,
    ]
  }
}