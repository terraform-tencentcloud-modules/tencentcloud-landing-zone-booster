################################################################################
# Waf instance vars
################################################################################
variable "goods_category" {
  description = "Billing order parameters. support: premium_clb, enterprise_clb, ultimate_clb."
  type        = string
  default     = "premium_clb"
}

variable "instance_name" {
  description = "Waf instance name."
  type        = string
  default     = ""
}

variable "time_span" {
  description = "Time interval."
  type        = number
  default     = 1
}

variable "time_unit" {
  description = "Time unit, support d, m, y. d: day, m: month, y: year."
  type        = string
  default     = "m"
}

variable "auto_renew_flag" {
  description = "Auto renew flag, 1: enable, 0: disable."
  type        = number
  default     = 1
}

variable "elastic_mode" {
  description = "Is elastic billing enabled, 1: enable, 0: disable."
  type        = number
  default     = 1
}

variable "qps_limit" {
  description = "QPS Limit, Minimum setting 10000. Only elastic_mode is 1, can be set."
  type        = number
  default     = 200000
}

variable "api_security" {
  description = "Whether to purchase API Security, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}

variable "bot_management" {
  description = "Whether to purchase Bot management, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}

################################################################################
# Waf clb domain vars
################################################################################
variable "domain_configs" {
  description = "Configuration object for WAF CLB domain protection"
  type = list(object({
    # Required parameters
    domain      = string # Domain name.
    region      = string # Regions of LB bound by domain.

    # Optional parameters with defaults
    is_cdn          = optional(number, 0)  # Whether a proxy has been enabled before WAF
    status          = optional(number, 1)  # Binding status between waf and LB, 0:not bind, 1:binding.
    engine          = optional(number, 20) # Protection Status.
    flow_mode       = optional(number, 1)  # WAF traffic mode, 1 cleaning mode, 0 mirroring mode.
    alb_type        = optional(string, "clb") # Load balancer type: clb, apisix or tsegw, default clb.
    bot_status      = optional(number, 0) # Whether to enable bot, 1 enable, 0 disable.
    api_safe_status = optional(number, 0) # Whether to enable api safe, 1 enable, 0 disable.
    ip_headers      = optional(list(string), []) # When is_cdn=3, this parameter needs to be filled in to indicate a custom header.

    # List of bound LB.
    load_balancer_set = optional(list(object({
      load_balancer_id   = string # LoadBalancer unique ID.
      load_balancer_name = string # LoadBalancer name.
      listener_id        = string # Unique ID of listener in LB.
      listener_name      = string # Listener name.
      vport              = number # LoadBalancer port.
      protocol           = string # Protocol of listener, http or https.
      region             = string # LoadBalancer region.
      zone               = string # LoadBalancer zone.
      vip                = optional(string) # LoadBalancer IP.
      load_balancer_type = optional(string) # Network type for load balancer.
    })), [])
  }))
  default = []
}

################################################################################
# Waf log post cls flow vars
################################################################################
variable "enable_cls_log" {
  description = "(Optional, String) The region where the CLS is delivered. The default value is ap-shanghai."
  type        = bool
  default     = false
}

variable "cls_region" {
  description = "(Optional, String) The region where the CLS is delivered. The default value is ap-shanghai."
  type        = string
  default     = "ap-shanghai"
}

variable "logset_name" {
  description = "(Optional, String) The name of the log set where the delivered CLS is located. The default value is waf_post_logset."
  type        = string
  default     = "waf_post_logset"
}

variable "log_topic_name" {
  description = "(Optional, String) The name of the log subject where the submitted CLS is located. The default value is waf_post_logtopic."
  type        = string
  default     = "waf_post_logtopic"
}

variable "log_type" {
  description = "(Optional, Int) 1- Access log, 2- Attack log, the default is access log."
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 2], var.log_type)
    error_message = "log_type must be 1 or 2."
  }
}

################################################################################
# Waf instance attack log post config vars
################################################################################
variable "attack_log_post" {
  description = "(Required, Int) Attack log delivery switch. 0- Disable, 1- Enable."
  type        = number
  validation {
    condition     = contains([0, 1], var.attack_log_post)
    error_message = "attack_log_post must be 0 or 1."
  }
  default = 0
}