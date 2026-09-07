###############################################################################
### Edgeone Zone domain ssl certificate resource
###############################################################################
resource "tencentcloud_teo_certificate_config" "cert" {
  count = var.ssl_cert != null ? 1 : 0

  zone_id = var.edgeone_zone_id
  host    = var.ssl_cert.host
  mode    = var.ssl_cert.mode

  dynamic "server_cert_info" {
    for_each = var.ssl_cert.mode == "sslcert" ? var.ssl_cert.server_cert_info : []
    content {
      cert_id     = server_cert_info.value.cert_id
      alias       = server_cert_info.value.alias
      type        = server_cert_info.value.type
      common_name = server_cert_info.value.common_name
      deploy_time = server_cert_info.value.deploy_time
      expire_time = server_cert_info.value.expire_time
      sign_algo   = server_cert_info.value.sign_algo
    }
  }

  timeouts {
    create = var.ssl_cert.timeouts.create
    update = var.ssl_cert.timeouts.update
  }
}
