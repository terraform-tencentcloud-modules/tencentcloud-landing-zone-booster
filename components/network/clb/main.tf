locals {
  create_log_set   = var.clb_instance.create_clb_log && var.clb_instance.log_set_id == null
  create_log_topic = var.clb_instance.create_clb_log && var.clb_instance.log_topic_id == null

  log_set_id   = local.create_log_set ? tencentcloud_clb_log_set.set[0].id : var.clb_instance.log_set_id
  log_topic_id = local.create_log_topic ? tencentcloud_clb_log_topic.topic[0].id : var.clb_instance.log_topic_id
}

################################################################################
### CLB Log Set / Topic / Attachment
################################################################################
resource "tencentcloud_clb_log_set" "set" {
  count = local.create_log_set ? 1 : 0

  period = var.clb_instance.clb_log_set_period
}

resource "tencentcloud_clb_log_topic" "topic" {
  count = local.create_log_topic ? 1 : 0

  log_set_id = local.log_set_id
  topic_name = var.clb_instance.clb_log_topic_name
  status     = var.clb_instance.clb_log_topic_status
}

# Attach the created/provided log set & topic to the CLB instance (equivalent to clb-log module)
resource "tencentcloud_clb_cls_log_attachment" "attachment" {
  count = var.clb_instance.create_clb_log ? 1 : 0

  load_balancer_id = tencentcloud_clb_instance.instance.id
  log_set_id       = local.log_set_id
  log_topic_id     = local.log_topic_id
}

################################################################################
### CLB Instance + SLA
################################################################################
resource "tencentcloud_clb_instance_sla_config" "sla_config" {
  count = var.clb_instance.sla_type == null || var.clb_instance.sla_type == "" ? 0 : 1

  sla_type         = var.clb_instance.sla_type
  load_balancer_id = tencentcloud_clb_instance.instance.id
}

resource "tencentcloud_clb_instance" "instance" {
  # base config
  project_id     = var.clb_instance.project_id
  clb_name       = var.clb_instance.clb_name
  network_type   = var.clb_instance.network_type
  vpc_id         = var.clb_instance.vpc_id
  subnet_id      = var.clb_instance.network_type == "INTERNAL" ? var.clb_instance.subnet_id : null
  zone_id        = var.clb_instance.network_type == "OPEN" ? var.clb_instance.availability_zone : null
  master_zone_id = var.clb_instance.network_type == "OPEN" ? var.clb_instance.master_availability_zone : null
  slave_zone_id  = var.clb_instance.network_type == "OPEN" ? var.clb_instance.slave_availability_zone : null
  delete_protect = var.clb_instance.delete_protect
  tags           = var.clb_instance.tags
  # vip
  dynamic_vip = var.clb_instance.network_type == "OPEN" ? var.clb_instance.dynamic_vip : false
  vip         = var.clb_instance.network_type == "OPEN" && try(var.clb_instance.dynamic_vip, false) ? null : var.clb_instance.vip
  # internet
  internet_charge_type       = var.clb_instance.network_type == "OPEN" ? var.clb_instance.internet_charge_type : null
  internet_bandwidth_max_out = var.clb_instance.network_type == "OPEN" ? var.clb_instance.internet_bandwidth_max_out : null
  bandwidth_package_id       = var.clb_instance.internet_charge_type == "BANDWIDTH_PACKAGE" ? var.clb_instance.bandwidth_package_id : null
  address_ip_version         = var.clb_instance.address_ip_version
  # log
  log_set_id   = local.log_set_id
  log_topic_id = local.log_topic_id

  # sla
  sla_type = var.clb_instance.sla_type

  # security groups
  security_groups = var.clb_instance.security_groups

  # snat
  snat_pro = var.clb_instance.snat_pro
  dynamic "snat_ips" {
    for_each = var.clb_instance.snat_ips
    content {
      subnet_id = snat_ips.value.subnet_id
      ip        = snat_ips.value.ip
    }
  }

  # target config
  load_balancer_pass_to_target = var.clb_instance.enable_pass_to_target
  target_region_info_region    = var.clb_instance.target_region_info_region
  target_region_info_vpc_id    = var.clb_instance.target_region_info_vpc_id

  lifecycle {
    ignore_changes = [
      tags["owner"],         # owner is a preserved tag used by Others system for service attaching CLBs
      tags["tke-clusterId"], # tke-clusterId is a preserved tag used by TKE for service attaching CLBs
      tags["ccs-clusterId"], # ccs-clusterId is a preserved tag used by CCS for service attaching CLBs
      tags["last-modified"], # last modified tag
    ]
  }
}

################################################################################
### CLB Listeners (HTTP/HTTPS/TCP/UDP/TCP_SSL/QUIC)
################################################################################
resource "tencentcloud_clb_listener" "this" {
  for_each = { for idx, l in var.clb_listeners : idx => l }

  # common
  clb_id        = tencentcloud_clb_instance.instance.id
  listener_name = each.value.listener_name
  port          = each.value.port
  protocol      = each.value.protocol

  # Certificate settings for HTTPS/TCP_SSL
  certificate_ssl_mode = contains(["HTTPS", "TCP_SSL"], each.value.protocol) ? each.value.certificate.ssl_mode : null
  certificate_id       = contains(["HTTPS", "TCP_SSL"], each.value.protocol) ? each.value.certificate.cert_id : null
  certificate_ca_id    = contains(["HTTPS", "TCP_SSL"], each.value.protocol) ? each.value.certificate.cert_ca_id : null
  sni_switch           = each.value.protocol == "HTTPS" ? each.value.certificate.sni_switch : null

  # Multi-certificate info
  dynamic "multi_cert_info" {
    for_each = (each.value.protocol == "TCP_SSL" || (each.value.protocol == "HTTPS" && !coalesce(each.value.certificate.sni_switch, false))) && each.value.multi_cert_info != null ? each.value.multi_cert_info : []
    content {
      cert_id_list = multi_cert_info.value.cert_id_list
      ssl_mode     = multi_cert_info.value.ssl_mode
    }
  }

  # TCP UDP
  scheduler           = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], each.value.protocol) ? each.value.scheduler : null
  target_type         = contains(["TCP", "UDP"], each.value.protocol) ? each.value.target_type : null
  session_expire_time = contains(["TCP", "UDP"], each.value.protocol) ? each.value.session_expire_time : null
  keepalive_enable    = contains(["HTTP", "HTTPS"], each.value.protocol) && each.value.keepalive_enable != null ? each.value.keepalive_enable : null
  # SNAT is only supported for HTTP/HTTPS listeners
  snat_enable = contains(["HTTP", "HTTPS"], each.value.protocol) ? each.value.snat_enable : null

  # TCP/UDP health check
  health_check_switch        = contains(["TCP", "UDP", "TCP_SSL", "QUIC"], each.value.protocol) && try(each.value.health_check.enabled, true)
  health_check_time_out      = try(each.value.health_check.time_out, null)
  health_check_interval_time = try(each.value.health_check.interval_time, null)
  health_check_health_num    = try(each.value.health_check.health_num, null)
  health_check_unhealth_num  = try(each.value.health_check.unhealth_num, null)
  health_check_type          = try(each.value.health_check.check_type, null)
  health_check_port          = try(each.value.health_check.port, null)
  health_check_http_code     = try(each.value.health_check.http_code, null)
  health_check_http_path     = try(each.value.health_check.http_path, null)
  health_check_http_domain   = try(each.value.health_check.http_domain, null)
  health_check_http_method   = try(each.value.health_check.http_method, null)
  health_check_http_version  = try(each.value.health_check.http_version, null)
  health_check_context_type  = try(each.value.health_check.context_type, null)
  health_check_send_context  = try(each.value.health_check.send_context, null)
  health_check_recv_context  = try(each.value.health_check.recv_context, null)
  health_source_ip_type      = try(each.value.health_check.source_ip_type, null)
}

# HTTP/HTTPS rules
resource "tencentcloud_clb_listener_rule" "this" {
  for_each = {
    for pair in flatten([
      for idx, l in var.clb_listeners : [
        for ridx, rule in l.listener_rules : {
          key          = "${idx}.${ridx}"
          listener_idx = idx
          rule_idx     = ridx
          rule         = rule
        }
      ]
    ]) : pair.key => pair
    if contains(["HTTP", "HTTPS"], var.clb_listeners[pair.listener_idx].protocol)
  }

  listener_id         = tencentcloud_clb_listener.this[each.value.listener_idx].listener_id
  clb_id              = tencentcloud_clb_instance.instance.id
  domain              = each.value.rule.domain
  url                 = each.value.rule.url
  scheduler           = each.value.rule.scheduler
  session_expire_time = each.value.rule.scheduler == "WRR" ? try(each.value.rule.session_expire_time, null) : null
  target_type         = each.value.rule.target_type
  forward_type        = each.value.rule.forward_type
  http2_switch        = each.value.rule.http2_switch
  quic                = each.value.rule.quic

  # Certificate for HTTPS with SNI
  certificate_ssl_mode = try(each.value.rule.certificate.ssl_mode, null)
  certificate_id       = try(each.value.rule.certificate.cert_id, null)
  certificate_ca_id    = try(each.value.rule.certificate.ssl_mode, null) == "MUTUAL" ? try(each.value.rule.certificate.cert_ca_id, null) : null

  # health check
  health_check_switch        = try(each.value.rule.health_check.enabled, true)
  health_check_type          = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.type, "HTTP") : null
  health_check_interval_time = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.interval, 5) : null
  health_check_health_num    = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.healthy_threshold, 3) : null
  health_check_unhealth_num  = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.unhealthy_threshold, 3) : null
  health_check_time_out      = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.timeout, 15) : null
  health_source_ip_type      = try(each.value.rule.health_check.enabled, true) ? try(each.value.rule.health_check.source_ip_type, 1) : null
  health_check_http_code     = try(each.value.rule.health_check.enabled, true) && contains(["HTTP", null], each.value.rule.health_check_type) ? try(each.value.rule.health_check.http_code, 2) : null
  health_check_http_method   = try(each.value.rule.health_check.enabled, true) && contains(["HTTP", null], each.value.rule.health_check_type) ? try(each.value.rule.health_check.method, "GET") : null
  health_check_http_path     = try(each.value.rule.health_check.enabled, true) && contains(["HTTP", null], each.value.rule.health_check_type) ? try(each.value.rule.health_check.path, "/") : null
  health_check_http_domain   = try(each.value.rule.health_check.enabled, true) && contains(["HTTP", null], each.value.rule.health_check_type) ? try(each.value.rule.health_check.domain, null) : null
}

# TCP/UDP target group binding
resource "tencentcloud_clb_attachment" "listener_attachment" {
  for_each = {
    for idx, l in var.clb_listeners : idx => l
    if contains(["TCP", "UDP", "TCP_SSL", "QUIC"], l.protocol) && try(l.listener_target_instance.enabled, false)
  }

  clb_id      = tencentcloud_clb_instance.instance.id
  listener_id = tencentcloud_clb_listener.this[each.key].listener_id

  dynamic "targets" {
    for_each = each.value.listener_target_instance.targets
    content {
      instance_id = targets.value.instance_id
      eni_ip      = targets.value.eni_ip
      port        = targets.value.port
      weight      = targets.value.weight
    }
  }
}

# HTTP/HTTPS target group binding
resource "tencentcloud_clb_attachment" "rule_attachment" {
  for_each = {
    for pair in flatten([
      for idx, l in var.clb_listeners : [
        for ridx, rule in l.listener_rules : {
          key          = "${idx}.${ridx}"
          listener_idx = idx
          rule_idx     = ridx
          rule         = rule
        }
      ]
    ]) : pair.key => pair
    if contains(["HTTP", "HTTPS"], var.clb_listeners[pair.listener_idx].protocol) && try(pair.rule.target_instance.enabled, false)
  }

  clb_id      = tencentcloud_clb_instance.instance.id
  listener_id = tencentcloud_clb_listener.this[each.value.listener_idx].listener_id
  rule_id     = tencentcloud_clb_listener_rule.this["${each.value.listener_idx}.${each.value.rule_idx}"].rule_id

  dynamic "targets" {
    for_each = each.value.rule.target_instance.targets
    content {
      instance_id = targets.value.instance_id
      eni_ip      = targets.value.eni_ip
      port        = targets.value.port
      weight      = targets.value.weight
    }
  }
}

################################################################################
### CLB Target Groups
################################################################################
resource "tencentcloud_clb_target_group" "this" {
  for_each = { for idx, tg in var.clb_target_groups : idx => tg }

  vpc_id            = var.clb_instance.vpc_id
  target_group_name = each.value.target_group_name
  type              = each.value.target_group_type
  protocol          = each.value.target_group_protocol
  port              = each.value.target_group_port
}

resource "tencentcloud_clb_target_group_instance_attachment" "this" {
  for_each = merge([
    for tg_idx, tg in var.clb_target_groups : {
      for inst_idx, inst in tg.target_instances : "${tg_idx}.${inst_idx}" => {
        target_group_idx = tg_idx
        inst             = inst
      }
    }
  ]...)

  target_group_id = tencentcloud_clb_target_group.this[each.value.target_group_idx].id
  port            = each.value.inst.port
  bind_ip         = each.value.inst.bind_ip
  weight          = each.value.inst.weight
}

################################################################################
### CLB Redirections
################################################################################
resource "tencentcloud_clb_redirection" "redirection" {
  for_each = { for idx, r in var.clb_redirections : idx => r }

  clb_id                  = tencentcloud_clb_instance.instance.id
  target_listener_id      = each.value.target_listener_id
  target_rule_id          = each.value.target_rule_id
  source_listener_id      = try(each.value.source_listener_id, null)
  source_rule_id          = try(each.value.source_rule_id, null)
  delete_all_auto_rewrite = try(each.value.delete_all_auto_rewrite, null)
  is_auto_rewrite         = try(each.value.is_auto_rewrite, null)
}

################################################################################
### CLB Customized Configs
################################################################################
resource "tencentcloud_clb_customized_config" "config" {
  for_each = { for idx, c in var.clb_custom_configs : idx => c }

  config_content    = replace(trimsuffix(replace(each.value.config_content, "\r\n", "\n"), "\n"), "\n", "\r\n")
  config_name       = each.value.config_name
  load_balancer_ids = [tencentcloud_clb_instance.instance.id]
}
