# Get node information
data "tencentcloud_organization_nodes" "org_nodes" {
}

locals {
  parent_node_id = [
    for item in data.tencentcloud_organization_nodes.org_nodes.items : item.node_id if item.parent_node_id == 0
  ][0]

  node_ids = { for k, node in tencentcloud_organization_org_node.nodes: k => node.id }
}

resource "tencentcloud_organization_org_node" "nodes" {
  for_each = var.org_nodes

  parent_node_id = (each.value.parent_id != null && each.value.parent_id != 0) ? each.value.parent_id : local.parent_node_id
  name           = each.value.name
  remark         = each.value.remark
}