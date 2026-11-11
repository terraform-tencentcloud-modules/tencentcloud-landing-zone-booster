################################################################################
### TKE cluster authentication options attachment
################################################################################
resource "tencentcloud_kubernetes_auth_attachment" "this" {
  cluster_id = var.cluster_id

  use_tke_default       = var.use_tke_default
  issuer                = var.issuer
  jwks_uri              = var.jwks_uri

  auto_create_discovery_anonymous_auth    = var.auto_create_discovery_anonymous_auth
  auto_create_oidc_config                 = var.auto_create_oidc_config
  auto_create_client_id                   = var.auto_create_client_id
  auto_install_pod_identity_webhook_addon = var.auto_install_pod_identity_webhook_addon
}

################################################################################
### CAM OIDC config data source
################################################################################
data "tencentcloud_cam_oidc_config" "this" {
  name = var.cluster_id

  result_output_file = var.result_output_file

  depends_on = [
    tencentcloud_kubernetes_auth_attachment.this
  ]
}