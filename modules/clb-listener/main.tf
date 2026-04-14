locals {
  is_tcp_udp    = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], var.protocol)
  is_http_https = contains(["HTTP", "HTTPS"], var.protocol)
}

#Create a listener. HTTP HTTPS TCP UDP is supported,TCP_SSL/QUIC is not supported
resource "tencentcloud_clb_listener" "this" {
  #common
  clb_id        = var.clb_id
  listener_name = var.listener_name
  port          = var.port
  protocol      = var.protocol

  #HTTPS
  certificate_ssl_mode = var.protocol == "HTTPS" ? var.certificate.ssl_mode : null
  certificate_id       = var.protocol == "HTTPS" ? var.certificate.cert_id : null
  certificate_ca_id    = var.protocol == "HTTPS" ? var.certificate.cert_ca_id : null
  sni_switch           = var.protocol == "HTTPS" ? var.certificate.sni_switch : null

  #TCP UDP
  scheduler           = local.is_tcp_udp ? var.scheduler : null
  target_type         = local.is_tcp_udp ? var.target_type : null
  session_expire_time = local.is_tcp_udp ? var.session_expire_time : null

  #TCP/UDP health check
  health_check_switch        = try(var.health_check.enabled, true) && local.is_tcp_udp
  health_check_type          = try(var.health_check.check_type, null)
  health_check_port          = try(var.health_check.port, null)
  health_check_interval_time = try(var.health_check.interval_time, null)
  health_check_http_code     = try(var.health_check.http_code, null)
  health_check_http_domain   = try(var.health_check.http_domain, null)
  health_check_http_method   = try(var.health_check.http_method, null)
  health_check_http_path     = try(var.health_check.http_path, null)
  health_check_http_version  = try(var.health_check.http_version, null)
  health_check_health_num    = try(var.health_check.health_num, null)
  health_check_unhealth_num  = try(var.health_check.unhealth_num, null)
  health_check_time_out      = try(var.health_check.time_out, null)
  health_check_context_type  = try(var.health_check.context_type, null)
  health_check_send_context  = try(var.health_check.send_context, null)
  health_check_recv_context  = try(var.health_check.recv_context, null)
  health_source_ip_type      = try(var.health_check.source_ip_type, null)
}

# TCP/UDP target group binding
resource "tencentcloud_clb_attachment" "listener_attachment" {
  count = local.is_tcp_udp && try(var.listener_target_instance.enabled, false) ? 1 : 0

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

# HTTP/HTTPS rules
resource "tencentcloud_clb_listener_rule" "this" {
  for_each = { for idx, rule in var.listener_rules : idx => rule if local.is_http_https }

  clb_id              = var.clb_id
  listener_id         = tencentcloud_clb_listener.this.listener_id
  domain              = each.value.domain
  url                 = each.value.url
  scheduler           = each.value.scheduler
  session_expire_time = each.value.scheduler == "WRR" ? try(each.value.session_expire_time, null) : null
  target_type         = each.value.target_type
  http2_switch        = each.value.http2_switch

  #  health check
  health_check_switch        = try(each.value.health_check.enabled, true)
  health_check_http_path     = try(each.value.health_check.enabled, true) ? try(each.value.health_check.path, "/") : null
  health_check_http_domain   = try(each.value.health_check.enabled, true) ? try(each.value.health_check.domain, null) : null
  health_check_interval_time = try(each.value.health_check.enabled, true) ? try(each.value.health_check.interval, 5) : null
  health_check_health_num    = try(each.value.health_check.enabled, true) ? try(each.value.health_check.healthy_threshold, 3) : null
  health_check_unhealth_num  = try(each.value.health_check.enabled, true) ? try(each.value.health_check.unhealthy_threshold, 3) : null
  health_check_http_code     = try(each.value.health_check.enabled, true) ? try(each.value.health_check.http_code, 2) : null
  health_check_http_method   = try(each.value.health_check.enabled, true) ? try(each.value.health_check.method, "GET") : null
  health_check_time_out      = try(each.value.health_check.enabled, true) ? try(each.value.health_check.timeout, 15) : null
  health_check_type          = try(each.value.health_check.enabled, true) ? try(each.value.health_check.type, "HTTP") : null
  health_source_ip_type      = try(each.value.health_check.enabled, true) ? try(each.value.health_check.source_ip_type, 1) : null
}

# HTTP HTTPS target group binding
resource "tencentcloud_clb_attachment" "rule_attachment" {
  for_each = {
    for idx, rule in var.listener_rules : idx => rule
    if local.is_http_https && try(rule.target_instance.enabled, false)
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