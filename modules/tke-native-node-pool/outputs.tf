################################################################################
# Node Pool Summary
################################################################################
output "node_pool_ids" {
  description = "Map of node pool name to its id."
  value       = { for k, v in tencentcloud_kubernetes_native_node_pool.this : k => v.id }
}

output "node_pool_names" {
  description = "Map of node pool name to its display name."
  value       = { for k, v in tencentcloud_kubernetes_native_node_pool.this : k => v.name }
}

output "node_pools" {
  description = "Map of node pool name to its full attributes."
  value = {
    for k, v in tencentcloud_kubernetes_native_node_pool.this : k => {
      id                   = v.id
      name                 = v.name
      cluster_id           = v.cluster_id
      type                 = v.type
      deletion_protection = v.deletion_protection
      unschedulable        = v.unschedulable
      subnet_ids           = v.native[0].subnet_ids
      instance_types       = v.native[0].instance_types
      security_group_ids   = v.native[0].security_group_ids
      instance_charge_type = v.native[0].instance_charge_type
      machine_type         = v.native[0].machine_type
      auto_repair          = v.native[0].auto_repair
      enable_autoscaling   = v.native[0].enable_autoscaling
      replicas             = v.native[0].replicas
      host_name_pattern    = v.native[0].host_name_pattern
      kubelet_args         = v.native[0].kubelet_args
      runtime_root_dir     = v.native[0].runtime_root_dir
      key_ids              = v.native[0].key_ids
      health_check_policy_name = v.native[0].health_check_policy_name
      labels               = v.labels
      taints               = v.taints
      annotations          = v.annotations
    }
  }
}

################################################################################
# Autoscaling Summary
################################################################################
output "autoscaling_config" {
  description = "Map of node pool name to its autoscaling configuration (null if scaling is not set)."
  value = {
    for k, v in tencentcloud_kubernetes_native_node_pool.this : k => try(v.native.scaling, null)
  }
}

################################################################################
# Node Summary (machines in each node pool)
################################################################################
output "node_pool_nodes" {
  description = "Map of node pool name to its node (machine) details."
  value = {
    for k, v in tencentcloud_kubernetes_native_node_pool.this : k => try(
      [
        for node in v.native.nodes : {
          instance_id   = node.instance_id
          instance_type = node.instance_type
          node_name     = node.node_name
          node_status   = node.node_status
          node_type     = node.node_type
          subnet_id     = node.subnet_id
          private_ip    = node.private_ip
          public_ip     = node.public_ip
          zone          = node.zone
        }
      ],
      []
    )
  }
}

output "node_instance_ids" {
  description = "Map of node pool name to the list of node instance ids."
  value = {
    for k, v in tencentcloud_kubernetes_native_node_pool.this : k => try(
      [for node in v.native.nodes : node.instance_id],
      []
    )
  }
}

output "node_private_ips" {
  description = "Map of node pool name to the list of node private ips."
  value = {
    for k, v in tencentcloud_kubernetes_native_node_pool.this : k => try(
      [for node in v.native.nodes : node.private_ip],
      []
    )
  }
}
