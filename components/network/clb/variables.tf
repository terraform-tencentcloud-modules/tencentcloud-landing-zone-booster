################################################################################
### CLB Instance Variables
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
    dynamic_vip = optional(bool)
    vip         = optional(string)
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
    create_clb_log     = optional(bool, false)
    log_set_id         = optional(string)
    log_topic_id       = optional(string)
    clb_log_set_period = optional(number, 7)              # days, max 90
    clb_log_topic_name = optional(string, "clb_topic")

    # ── Advanced ──
    associate_endpoint = optional(string)
  })

  validation {
    condition     = contains(["OPEN", "INTERNAL"], coalesce(var.clb.network_type, "OPEN"))
    error_message = "network_type must be either OPEN or INTERNAL."
  }

  validation {
    condition = (
      coalesce(var.clb.network_type, "OPEN") == "INTERNAL"
      ? var.clb.subnet_id != null
      : true
    )
    error_message = "subnet_id is required when network_type is INTERNAL."
  }

  validation {
    condition = (
      coalesce(var.clb.internet_charge_type, "TRAFFIC_POSTPAID_BY_HOUR") == "BANDWIDTH_PACKAGE"
      ? var.clb.bandwidth_package_id != null
      : true
    )
    error_message = "bandwidth_package_id is required when internet_charge_type is BANDWIDTH_PACKAGE."
  }
}

################################################################################
### CLB Listeners Variables
################################################################################


################################################################################
### CLB Listener Rules Variables (for HTTP/HTTPS listeners)
################################################################################

################################################################################
### CLB Redirections Variables
################################################################################


################################################################################
### CLB Attachments Variables
################################################################################
