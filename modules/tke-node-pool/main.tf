resource "tencentcloud_kubernetes_node_pool" "this" {
  for_each = var.node_pool

  cluster_id               = var.cluster_id
  vpc_id                   = var.vpc_id
  name                     = try(each.value.name, each.key)
  max_size                 = try(each.value.max_size, each.value.min_size, 1)
  min_size                 = try(each.value.min_size, each.value.max_size, 1)
  subnet_ids               = try(each.value.subnet_ids, [])
  retry_policy             = try(each.value.retry_policy, "IMMEDIATE_RETRY")
  desired_capacity         = try(each.value.desired_capacity, null)
  enable_auto_scale        = try(each.value.enable_auto_scale, true)
  multi_zone_subnet_policy = try(each.value.multi_zone_subnet_policy, "EQUALITY")
  node_os                  = try(each.value.node_os, "tlinux4_x86_64_public")
  delete_keep_instance     = try(each.value.delete_keep_instance, false)
  deletion_protection      = try(each.value.deletion_protection, false)
  auto_update_instance_tags = try(each.value.auto_update_instance_tags, null)

  dynamic "auto_scaling_config" {
    for_each = try(each.value.auto_scaling_config, {})
    content {
      instance_type              = try(auto_scaling_config.value.instance_type, null)
      backup_instance_types      = try(auto_scaling_config.value.backup_instance_types, null)
      system_disk_type           = try(auto_scaling_config.value.system_disk_type, "CLOUD_PREMIUM")
      system_disk_size           = try(auto_scaling_config.value.system_disk_size, 50)
      orderly_security_group_ids = try(auto_scaling_config.value.orderly_security_group_ids, null)
      key_ids                    = try(auto_scaling_config.value.key_ids, null)

      public_ip_assigned         = try(auto_scaling_config.value.public_ip_assigned, false)
      internet_charge_type       = try(auto_scaling_config.value.internet_charge_type, null)       #"TRAFFIC_POSTPAID_BY_HOUR")
      internet_max_bandwidth_out = try(auto_scaling_config.value.internet_max_bandwidth_out, null) # 10)
      bandwidth_package_id       = try(auto_scaling_config.value.bandwidth_package_id, null)
      spot_instance_type         = try(auto_scaling_config.value.spot_instance_type, null)
      spot_max_price             = try(auto_scaling_config.value.spot_max_price, null)

      instance_charge_type                    = try(auto_scaling_config.value.instance_charge_type, null)
      instance_charge_type_prepaid_period     = try(auto_scaling_config.value.instance_charge_type_prepaid_period, null)
      instance_charge_type_prepaid_renew_flag = try(auto_scaling_config.value.instance_charge_type_prepaid_renew_flag, null)

      cam_role_name = try(auto_scaling_config.value.cam_role_name, null)

      password                  = try(auto_scaling_config.value.password, random_password.worker_pwd.result, null)
      enhanced_security_service = try(auto_scaling_config.value.enhanced_security_service, true)
      enhanced_monitor_service  = try(auto_scaling_config.value.enhanced_monitor_service, true)
      host_name                 = try(auto_scaling_config.value.host_name, null)
      host_name_style           = try(auto_scaling_config.value.host_name_style, null)
      instance_name             = try(auto_scaling_config.value.instance_name, null)
      instance_name_style       = try(auto_scaling_config.value.instance_name_style, null)

      dynamic "data_disk" {
        for_each = try(each.value.data_disk, [])
        content {
          disk_type            = try(data_disk.value.disk_type, "CLOUD_PREMIUM")
          disk_size            = try(data_disk.value.disk_size, 50)
          delete_with_instance = try(data_disk.value.delete_with_instance, false)
        }
      }
    }
  }

  dynamic "taints" {
    for_each = try(each.value.taints, {})
    content {
      key    = try(taints.value.key, null)
      value  = try(taints.value.value, null)
      effect = try(taints.value.effect, null)
    }
  }

  dynamic "annotations" {
    for_each = try(each.value.annotations, [])
    content {
      name = annotations.value.name
      value = annotations.value.value
    }
  }

  dynamic "node_config" {
    for_each = try(each.value.node_config, null)
    content {
      dynamic "data_disk" {
        for_each = try(each.value.data_disk, [])
        content {
          disk_type             = try(data_disk.value.disk_type, "CLOUD_PREMIUM")
          disk_size             = try(data_disk.value.disk_size, 50)
          auto_format_and_mount = try(data_disk.value.auto_format_and_mount, true)
          file_system           = try(data_disk.value.file_system, "xfs")
          mount_target          = try(each.value.docker_graph_path, "/var/lib/containerd")
        }
      }
      docker_graph_path = try(each.value.docker_graph_path, "/var/lib/containerd")
      extra_args        = try(node_config.value.extra_args, null)
    }
  }
  
  labels = try(each.value.labels, null)
  tags   = each.value.tags

  lifecycle {
    ignore_changes = [
      desired_capacity,         # desired_capacity should be controlled by auto scaling
      auto_update_instance_tags # This field is forceNew, please do that by destroying resource but not modifying this parameter
    ]
  }
}