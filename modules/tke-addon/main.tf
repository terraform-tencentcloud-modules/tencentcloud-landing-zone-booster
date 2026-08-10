resource "tencentcloud_kubernetes_addon" "addons" {
  for_each = { for addon in var.cluster_addons : addon.addon_name => addon }

  cluster_id    = var.cluster_id
  addon_name    = each.value.addon_name
  addon_version = each.value.addon_version
  raw_values    = each.value.raw_values
}