resource "tencentcloud_waf_clb_domain" "tc_waf_clb_domain" {
  instance_id       = var.instance_id
  domain            = var.domain
  is_cdn            = var.is_cdn
  status            = var.status
  engine            = var.engine
  region            = var.region
  flow_mode         = var.flow_mode
  alb_type          = var.alb_type
  bot_status        = var.bot_status
  api_safe_status   = var.api_safe_status
  ip_headers        = var.ip_headers
  dynamic "load_balancer_set" {
    for_each = var.load_balancer_set
    content {
      load_balancer_id   = load_balancer_set.value.load_balancer_id
      load_balancer_name = load_balancer_set.value.load_balancer_name
      listener_id        = load_balancer_set.value.listener_id
      listener_name      = load_balancer_set.value.listener_name
      vip                = load_balancer_set.value.vip
      vport              = load_balancer_set.value.vport
      region             = load_balancer_set.value.region
      protocol           = load_balancer_set.value.protocol
      zone               = load_balancer_set.value.zone
      load_balancer_type = try(load_balancer_set.value.load_balancer_type, "OPEN")
    }
  }
}