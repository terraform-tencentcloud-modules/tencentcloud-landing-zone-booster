terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "waf" {
  source = "../../../../components/security/waf"

  # WAF instance
  instance_name   = "waf-instance-test"
  goods_category  = "premium_clb"
  time_span       = 1
  time_unit       = "m"
  auto_renew_flag = 0

  # elastic config
  elastic_mode = 1
  qps_limit    = 50000

  # api protect
  api_security   = 1  # enable API security
  bot_management = 1  # enable BOT management

  # log to cls
  cls_region     = "ap-shanghai"
  log_type       = 1
  log_topic_name = "waf_security_logs"
  logset_name    = "security_logset"

  # enable attack log post
  attack_log_post = 1

  # domain configs
  domain_configs = [
    {
      domain     = "www.example.com"
      region     = "ap-shanghai"
      alb_type   = "clb"
      is_cdn     = 0
      ip_headers = []
      status     = 1
      
      # protection config
      engine          = 20
      flow_mode       = 1
      bot_status      = 1
      api_safe_status = 1
      
      # clb listeners
      load_balancer_set = [
        {
          load_balancer_id   = "lb-12345678"
          load_balancer_name = "production-lb"
          listener_id        = "lbl-12345678"
          listener_name      = "https-listener"
          vport              = 443
          protocol           = "HTTPS"
          region             = "ap-shanghai"
          zone               = "ap-shanghai-5"
        }
      ]
    },
    # CDN protection
    {
      domain    = "cdn.example.com"
      region    = "ap-shanghai"
      is_cdn    = 1
      ip_headers = ["X-Forwarded-For", "X-Real-IP"]
    }
  ]
}