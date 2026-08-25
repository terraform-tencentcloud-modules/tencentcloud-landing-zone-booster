#Create a listener. HTTP HTTPS TCP UDP is supported,TCP_SSL/QUIC is not supported
resource "tencentcloud_clb_listener" "this" {
  #common
  clb_id        = var.clb_id
  listener_name = var.listener_name
  port          = var.port
  protocol      = var.protocol

  # Certificate settings for HTTPS/TCP_SSL
  certificate_ssl_mode = contains(["HTTPS", "TCP_SSL"], var.protocol) ? var.certificate.ssl_mode : null
  certificate_id       = contains(["HTTPS", "TCP_SSL"], var.protocol) ? var.certificate.cert_id : null
  certificate_ca_id    = contains(["HTTPS", "TCP_SSL"], var.protocol) ? var.certificate.cert_ca_id : null
  sni_switch           = var.protocol == "HTTPS" ? var.certificate.sni_switch : null

  # Multi-certificate info (for HTTPS with SNI disabled, cannot be used with certificate_* at the same time)
  dynamic "multi_cert_info" {
    for_each = (var.protocol == "TCP_SSL" || (var.protocol == "HTTPS" && !each.value.sni_switch)) && var.multi_cert_info != null ? var.multi_cert_info : []
    content {
      cert_id_list = multi_cert_info.value.cert_id_list
      ssl_mode     = multi_cert_info.value.ssl_mode
    }
  }

  #TCP UDP
  scheduler           = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], var.protocol) ? var.scheduler : null
  target_type         = contains(["TCP", "UDP"], var.protocol) ? var.target_type : null
  session_expire_time = contains(["TCP", "UDP"], var.protocol) ? var.session_expire_time : null
  keepalive_enable    = contains(["HTTP", "HTTPS"], var.protocol) && var.keepalive_enable != null ? each.value.keepalive_enable : null
  snat_enable         = var.snat_enable

  #TCP/UDP health check
  health_check_switch        = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], var.protocol) && try(var.health_check.enabled, true)
  health_check_time_out      = try(var.health_check.time_out, null)
  health_check_interval_time = try(var.health_check.interval_time, null)
  health_check_health_num    = try(var.health_check.health_num, null)
  health_check_unhealth_num  = try(var.health_check.unhealth_num, null)
  health_check_type          = try(var.health_check.check_type, null)
  health_check_port          = try(var.health_check.port, null)
  # HTTP health check parameters (only when health_check_type is HTTP)
  health_check_http_code     = try(var.health_check.http_code, null)
  health_check_http_path     = try(var.health_check.http_path, null)
  health_check_http_domain   = try(var.health_check.http_domain, null)
  health_check_http_method   = try(var.health_check.http_method, null)
  health_check_http_version  = try(var.health_check.http_version, null)
  # CUSTOM health check parameters (only when health_check_type is CUSTOM)
  health_check_context_type  = try(var.health_check.context_type, null)
  health_check_send_context  = try(var.health_check.send_context, null)
  health_check_recv_context  = try(var.health_check.recv_context, null)
  health_source_ip_type      = try(var.health_check.source_ip_type, null)
}

# HTTP/HTTPS rules
resource "tencentcloud_clb_listener_rule" "this" {
  for_each = { for idx, rule in var.listener_rules : idx => rule if contains(["HTTP", "HTTPS"], var.protocol) }

  listener_id         = tencentcloud_clb_listener.this.listener_id
  clb_id              = var.clb_id
  domain              = each.value.domain
  url                 = each.value.url
  scheduler           = each.value.scheduler
  session_expire_time = each.value.scheduler == "WRR" ? try(each.value.session_expire_time, null) : null
  target_type         = each.value.target_type
  forward_type        = each.value.forward_type
  http2_switch        = each.value.http2_switch
  # QUIC
  quic                = each.value.quic

  # Certificate for HTTPS with SNI
  certificate_ssl_mode = try(each.value.certificate.ssl_mode, null)
  certificate_id       = try(each.value.certificate.cert_id, null)
  certificate_ca_id    = try(each.value.certificate.ssl_mode, null) == "MUTUAL" ? try(each.value.certificate.cert_ca_id, null) : null

  #  health check
  health_check_switch        = try(each.value.health_check.enabled, true)
  health_check_type          = try(each.value.health_check.enabled, true) ? try(each.value.health_check.type, "HTTP") : null
  health_check_interval_time = try(each.value.health_check.enabled, true) ? try(each.value.health_check.interval, 5) : null
  health_check_health_num    = try(each.value.health_check.enabled, true) ? try(each.value.health_check.healthy_threshold, 3) : null
  health_check_unhealth_num  = try(each.value.health_check.enabled, true) ? try(each.value.health_check.unhealthy_threshold, 3) : null
  health_check_time_out      = try(each.value.health_check.enabled, true) ? try(each.value.health_check.timeout, 15) : null
  health_source_ip_type      = try(each.value.health_check.enabled, true) ? try(each.value.health_check.source_ip_type, 1) : null
  # HTTP health check parameters (only when health_check_type is HTTP)
  health_check_http_code     = try(each.value.health_check.enabled, true) && contains(["HTTP", null], each.value.health_check_type) ? try(each.value.health_check.http_code, 2) : null
  health_check_http_method   = try(each.value.health_check.enabled, true) && contains(["HTTP", null], each.value.health_check_type) ? try(each.value.health_check.method, "GET") : null
  health_check_http_path     = try(each.value.health_check.enabled, true) && contains(["HTTP", null], each.value.health_check_type) ? try(each.value.health_check.path, "/") : null
  health_check_http_domain   = try(each.value.health_check.enabled, true) && contains(["HTTP", null], each.value.health_check_type) ? try(each.value.health_check.domain, null) : null
}

# TCP/UDP target group binding
resource "tencentcloud_clb_attachment" "listener_attachment" {
  count = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], var.protocol) && try(var.listener_target_instance.enabled, false) ? 1 : 0

  clb_id      = var.clb_id
  listener_id = tencentcloud_clb_listener.this.listener_id

  dynamic "targets" {
    for_each = var.listener_target_instance.targets
    content {
      instance_id = targets.value.instance_id
      eni_ip      = targets.value.eni_ip
      port        = targets.value.port
      weight      = targets.value.weight
    }
  }
}

# HTTP HTTPS target group binding
resource "tencentcloud_clb_attachment" "rule_attachment" {
  for_each = {
    for idx, rule in var.listener_rules : idx => rule
    if contains(["HTTP", "HTTPS"], var.protocol) && try(rule.target_instance.enabled, false)
  }

  clb_id      = var.clb_id
  listener_id = tencentcloud_clb_listener.this.listener_id
  rule_id     = tencentcloud_clb_listener_rule.this[each.key].rule_id

  dynamic "targets" {
    for_each = each.value.target_instance.targets
    content {
      instance_id = targets.value.instance_id
      eni_ip      = targets.value.eni_ip
      port        = targets.value.port
      weight      = targets.value.weight
    }
  }
}