resource "tencentcloud_kubernetes_cluster_endpoint" "endpoints" {
  count = var.cluster_public_access || var.cluster_private_access ? 1 : 0
  
  cluster_id                      = var.cluster_id
  cluster_internet                = var.cluster_public_access
  cluster_internet_domain         = var.cluster_internet_domain
  cluster_internet_security_group = var.cluster_public_access ? var.cluster_security_group_id : null
  cluster_intranet                = var.cluster_private_access
  cluster_intranet_domain         = var.cluster_intranet_domain
  cluster_intranet_subnet_id      = var.cluster_private_access ? var.cluster_private_access_subnet_id : null
}