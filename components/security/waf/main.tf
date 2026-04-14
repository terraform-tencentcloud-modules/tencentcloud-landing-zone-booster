resource "tencentcloud_waf_clb_instance" "this" {
  goods_category  = var.goods_category
  instance_name   = var.instance_name
  time_span       = var.time_span
  time_unit       = var.time_unit
  auto_renew_flag = var.auto_renew_flag
  elastic_mode    = var.elastic_mode
  qps_limit       = var.qps_limit
  api_security    = var.api_security
  bot_management  = var.bot_management
}

resource "tencentcloud_waf_clb_domain" "waf_clb_domain" {
  count = length(var.domain_configs)

  instance_id       = tencentcloud_waf_clb_instance.this.instance_id
  domain            = var.domain_configs[count.index].domain
  is_cdn            = var.domain_configs[count.index].is_cdn
  status            = var.domain_configs[count.index].status
  engine            = var.domain_configs[count.index].engine
  region            = var.domain_configs[count.index].region
  flow_mode         = var.domain_configs[count.index].flow_mode
  alb_type          = var.domain_configs[count.index].alb_type
  bot_status        = var.domain_configs[count.index].bot_status
  api_safe_status   = var.domain_configs[count.index].api_safe_status
  ip_headers        = var.domain_configs[count.index].ip_headers
  dynamic "load_balancer_set" {
    for_each = var.domain_configs[count.index].load_balancer_set
    content {
      load_balancer_type = load_balancer_set.value.load_balancer_type
      load_balancer_id   = load_balancer_set.value.load_balancer_id
      load_balancer_name = load_balancer_set.value.load_balancer_name
      listener_id        = load_balancer_set.value.listener_id
      listener_name      = load_balancer_set.value.listener_name
      vport              = load_balancer_set.value.vport
      region             = load_balancer_set.value.region
      protocol           = load_balancer_set.value.protocol
      zone               = load_balancer_set.value.zone
      vip                = load_balancer_set.value.vip
    }
  }

  depends_on = [ tencentcloud_waf_clb_instance.this ]
}

resource "tencentcloud_waf_log_post_cls_flow" "log_post_cls_flow" {
  cls_region     = var.cls_region
  log_topic_name = var.log_topic_name
  log_type       = var.log_type
  logset_name    = var.logset_name

  depends_on = [ tencentcloud_waf_clb_instance.this ]
}

# Only enterprise version and above are supported for activation
resource "tencentcloud_waf_instance_attack_log_post_config" "attack_log_post_config" {
  instance_id     = tencentcloud_waf_clb_instance.this.instance_id
  attack_log_post = var.attack_log_post

  depends_on = [ tencentcloud_waf_clb_instance.this ]
}