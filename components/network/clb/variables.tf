################################################################################
### CLB Instance Variables (single composite object)
################################################################################
variable "clb_instance" {
  description = "CLB instance configuration."
  type = object({
    # ── Required ──
    clb_name = string # Name of the CLB instance
    vpc_id   = string # VPC ID of the CLB instance

    # ── Base ──
    project_id               = optional(number, 0)
    network_type             = optional(string, "OPEN") # OPEN / INTERNAL
    subnet_id                = optional(string)         # Required when network_type = INTERNAL
    availability_zone        = optional(string)         # Only for OPEN
    master_availability_zone = optional(string)         # Only for OPEN, cross-AZ DR
    slave_availability_zone  = optional(string)         # Only for OPEN, cross-AZ DR
    delete_protect           = optional(bool, false)
    tags                     = optional(map(string), {})

    # ── VIP ──
    dynamic_vip        = optional(bool)
    vip                = optional(string)
    address_ip_version = optional(string) # ipv4 / ipv6 / IPv6FullChain, only for OPEN

    # ── Internet (only for OPEN) ──
    internet_charge_type       = optional(string, "TRAFFIC_POSTPAID_BY_HOUR")
    internet_bandwidth_max_out = optional(number, 10) # Mbps
    bandwidth_package_id       = optional(string)     # Required when internet_charge_type = BANDWIDTH_PACKAGE

    # ── SLA ──
    sla_type = optional(string) # Required for LCU-supported instances

    # ── Security groups ──
    security_groups = optional(list(string), [])

    # ── SNAT ──
    snat_pro = optional(bool)
    snat_ips = optional(list(object({
      subnet_id = string
      ip        = optional(string)
    })), [])

    # ── Backend target ──
    enable_pass_to_target     = optional(bool, true)
    target_region_info_region = optional(string)
    target_region_info_vpc_id = optional(string)

    # ── CLB log ──
    create_clb_log       = optional(bool, false)
    log_set_id           = optional(string)
    log_topic_id         = optional(string)
    clb_log_set_period   = optional(number, 7) # days, max 90
    clb_log_topic_name   = optional(string, "clb_topic")
    clb_log_topic_status = optional(bool, true) # enable/disable the log topic

    # ── Advanced ──
    associate_endpoint = optional(string)
  })

  validation {
    condition     = contains(["OPEN", "INTERNAL"], coalesce(var.clb_instance.network_type, "OPEN"))
    error_message = "network_type must be either OPEN or INTERNAL."
  }

  validation {
    condition = (
      coalesce(var.clb_instance.network_type, "OPEN") == "INTERNAL"
      ? var.clb_instance.subnet_id != null
      : true
    )
    error_message = "subnet_id is required when network_type is INTERNAL."
  }

  validation {
    condition = (
      coalesce(var.clb_instance.internet_charge_type, "TRAFFIC_POSTPAID_BY_HOUR") == "BANDWIDTH_PACKAGE"
      ? var.clb_instance.bandwidth_package_id != null
      : true
    )
    error_message = "bandwidth_package_id is required when internet_charge_type is BANDWIDTH_PACKAGE."
  }
}

################################################################################
### CLB Listeners Variables (collection)
################################################################################
variable "clb_listeners" {
  description = "List of CLB listeners (HTTP/HTTPS/TCP/UDP/TCP_SSL/QUIC) with optional rules and target bindings."
  type = list(object({
    listener_name       = string
    protocol            = string # HTTP / HTTPS / TCP / UDP / TCP_SSL / QUIC
    port                = optional(number)
    scheduler           = optional(string, "WRR")         # WRR / LEAST_CONN
    target_type         = optional(string, "TARGETGROUP") # NODE / TARGETGROUP
    session_expire_time = optional(number)
    keepalive_enable    = optional(number)
    snat_enable         = optional(bool, false)

    certificate = optional(object({
      ssl_mode   = optional(string) # UNIDIRECTIONAL / MUTUAL
      cert_id    = optional(string)
      cert_ca_id = optional(string)
      sni_switch = optional(bool)
    }))

    multi_cert_info = optional(list(object({
      ssl_mode     = optional(string, "UNIDIRECTIONAL")
      cert_id_list = list(string)
    })))

    health_check = optional(object({
      enabled        = optional(bool, true)
      check_type     = optional(string)
      port           = optional(number)
      interval_time  = optional(number)
      http_code      = optional(number)
      http_domain    = optional(string)
      http_method    = optional(string)
      http_path      = optional(string)
      http_version   = optional(string)
      health_num     = optional(number)
      unhealth_num   = optional(number)
      time_out       = optional(number)
      context_type   = optional(string)
      send_context   = optional(string)
      recv_context   = optional(string)
      source_ip_type = optional(number)
    }))

    # TCP/UDP target group binding
    listener_target_instance = optional(object({
      enabled = optional(bool, false)
      targets = list(object({
        instance_id = optional(string, "")
        eni_ip      = optional(string, "")
        port        = number
        weight      = optional(number, 10)
      }))
    }))

    # HTTP/HTTPS listener rules
    listener_rules = optional(list(object({
      domain              = string
      url                 = string
      session_expire_time = optional(number)
      http2_switch        = optional(bool)
      scheduler           = optional(string, "WRR")
      target_type         = optional(string, "NODE")
      forward_type        = optional(string, "HTTP")
      quic                = optional(bool, false)

      certificate = optional(object({
        ssl_mode   = optional(string)
        cert_id    = optional(string)
        cert_ca_id = optional(string)
      }))

      health_check = optional(object({
        enabled             = optional(bool, true)
        type                = optional(string, "HTTP")
        path                = optional(string, "/")
        domain              = optional(string)
        timeout             = optional(number, 2)
        interval            = optional(number, 5)
        healthy_threshold   = optional(number, 3)
        unhealthy_threshold = optional(number, 3)
        http_code           = optional(number, 2)
        method              = optional(string, "GET")
        source_ip_type      = optional(number, 1)
      }), {})

      target_instance = object({
        enabled = optional(bool, false)
        targets = list(object({
          instance_id = optional(string, "")
          eni_ip      = optional(string, "")
          port        = number
          weight      = optional(number, 10)
        }))
      })
    })), [])
  }))
  default = []
}

################################################################################
### CLB Target Groups Variables (collection)
################################################################################
variable "clb_target_groups" {
  description = "List of CLB target groups with optional instance attachments."
  type = list(object({
    target_group_name     = optional(string)
    target_group_type     = optional(string) # v1 / v2
    target_group_protocol = optional(string) # TCP / UDP / HTTP / HTTPS / GRPC (required for v2)
    target_group_port     = optional(number)
    target_instances = optional(list(object({
      bind_ip = string
      port    = number
      weight  = optional(number, 10)
    })), [])
  }))
  default = []
}

################################################################################
### CLB Redirections Variables (collection)
################################################################################
variable "clb_redirections" {
  description = "List of CLB redirection configs."
  type = list(object({
    target_listener_id      = string
    target_rule_id          = string
    source_listener_id      = optional(string)
    source_rule_id          = optional(string)
    delete_all_auto_rewrite = optional(bool)
    is_auto_rewrite         = optional(bool)
  }))
  default = []
}

################################################################################
### CLB Customized Configs Variables (collection)
################################################################################
variable "clb_custom_configs" {
  description = "List of CLB customized configs (applied to the CLB instance)."
  type = list(object({
    config_name    = optional(string, "default-lb-config")
    config_content = optional(string, "")
  }))
  default = []
}
