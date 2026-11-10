resource "tencentcloud_kubernetes_serverless_node_pool" "this" {
  for_each = { for node_pool in var.serverless_node_pool : node_pool.name => node_pool}

  cluster_id         = var.cluster_id
  name               = each.value.name
  security_group_ids = each.value.security_group_ids
  labels             = each.value.labels

  dynamic "serverless_nodes" {
    for_each = each.value.serverless_nodes
    content {
      display_name = try(serverless_nodes.value.display_name, null)
      subnet_id    = try(serverless_nodes.value.subnet_id, null)
    }
  }

  dynamic "taints" {
    for_each = each.value.taints
    content {
      effect = taints.value.effect
      key    = taints.value.key
      value  = taints.value.value
    }
  }
}