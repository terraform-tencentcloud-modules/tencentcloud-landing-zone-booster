# Get node information
data "tencentcloud_organization_nodes" "org_nodes" {}

locals {
  parent_node_id = [
    for item in data.tencentcloud_organization_nodes.org_nodes.items : item.node_id if item.parent_node_id == 0
  ][0]

  l1_node_list = { for node in var.org_nodes: node.name => {
    parent_id = node.parent_id
    name      = node.name
    remark    = node.remark
  }}
  l1_node_ids = { for k, node in tencentcloud_organization_org_node.l1_nodes: k => node.id }

  l2_nodes = flatten([
    for l1_node in var.org_nodes: [
      for l2_node in l1_node.sub_nodes : {
        k:              format("%s/%s", l1_node.name, l2_node.name)
        l1_node_name:   l1_node.name,
        l2_node_name:   l2_node.name
        l2_node_remark: l2_node.remark
      }
    ]
  ])
  l2_node_list = { for l2 in local.l2_nodes: l2.k => {
    parent_id = local.l1_node_ids[l2.l1_node_name]
    name      = l2.l2_node_name
    remark    = l2.l2_node_remark
  } }
  l2_node_ids = { for k, node in tencentcloud_organization_org_node.l2_nodes: k => node.id }
}

resource "tencentcloud_organization_org_node" "l1_nodes" {
  for_each = local.l1_node_list

  parent_node_id = each.value.parent_id != null ? each.value.parent_id : local.parent_node_id
  name           = each.value.name
  remark         = each.value.remark
}

resource "tencentcloud_organization_org_node" "l2_nodes" {
  for_each = local.l2_node_list

  parent_node_id = each.value.parent_id != null ? each.value.parent_id : local.parent_node_id
  name           = each.value.name
  remark         = each.value.remark

  depends_on = [ tencentcloud_organization_org_node.l1_nodes ]
}