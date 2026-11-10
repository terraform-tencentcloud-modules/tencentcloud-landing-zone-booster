resource "tencentcloud_waf_saas_domain" "tc_waf_saas_domain" {
  domain      = var.domain
  instance_id = var.instance_id

  dynamic "ports" {
    for_each = var.ports
    content {
      port              = ports.value.port
      protocol          = ports.value.protocol
      upstream_port     = ports.value.upstream_port
      upstream_protocol = ports.value.upstream_protocol
    }
  }

  # optional parameters
  active_check    = var.active_check
  api_safe_status = var.api_safe_status
  bot_status      = var.bot_status
  cert_type       = var.cert_type
  cert            = var.cert
  cipher_template = var.cipher_template
  ciphers         = var.ciphers
  cls_status      = var.cls_status
  https_rewrite   = var.https_rewrite
  https_upstream_port = var.https_upstream_port
  ip_headers      = var.ip_headers
  is_cdn          = var.is_cdn
  is_http2        = var.is_http2
  is_keep_alive    = var.is_keep_alive
  is_websocket    = var.is_websocket
  load_balance = var.load_balance
  private_key      = var.private_key
  proxy_read_timeout        = var.proxy_read_timeout    
  proxy_send_timeout        = var.proxy_send_timeout
  sni_host = var.sni_host
  sni_type = var.sni_type
  src_list        = var.src_list
  ssl_id        = var.ssl_id
  status         = var.status
  tls_version    = var.tls_version
  upstream_domain = var.upstream_domain
  upstream_scheme = var.upstream_scheme
  upstream_type   = var.upstream_type
  weights        = var.weights
  xff_reset     = var.xff_reset
}
