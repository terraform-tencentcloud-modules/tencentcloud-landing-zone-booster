###############################################################################
### Edgeone Zone variables
###############################################################################
variable "edgeone_zone" {
  description = "Edgeone zone"
  type = object({
    area            = string                # the default value is overseas. global: Global availability zone. mainland: Chinese mainland availability zone. overseas: Global availability zone (excluding Chinese mainland).
    plan_id         = string                # The target Plan ID to be bound. 
    type            = string                # Site access type. The value of this parameter is as follows, and the default is partial if not filled in:partial: CNAME access; full: NS access; noDomainAccess: No domain access.
    zone_name       = string                # Site domain name.
    alias_zone_name = optional(string)      # Alias site identifier. Limit the input to a combination of numbers, English, - and _, within 20 characters.
    paused          = optional(bool, false) # Indicates whether the site is disabled.
  })
}

###############################################################################
### L7 Acceleration Setting variables
###############################################################################
variable "l7_acc_setting" {
  description = "EdgeOne L7 acceleration setting configuration."

  type = list(object({
    accelerate_mainland = optional(object({
      switch = string # on/off
    }))
    cache = optional(object({
      custom_time = optional(object({
        cache_time = optional(number, 2592000)
        switch     = string # on/off
      }))
      follow_origin = optional(object({
        switch                 = string # on/off
        default_cache          = optional(string, "off")
        default_cache_strategy = optional(string, "on")
        default_cache_time     = optional(number, 0)
      }))
      no_cache = optional(object({
        switch = string # on/off
      }))
    }))
    cache_key = optional(object({
      full_url_cache = optional(string, "on")
      ignore_case    = optional(string, "off")
      query_string = optional(object({
        action = optional(string) # includeCustom/excludeCustom
        switch = optional(string, "off")
        values = optional(list(string))
      }))
    }))
    cache_prefresh = optional(object({
      switch             = string # on/off
      cache_time_percent = optional(number, 90)
    }))
    client_ip_country = optional(object({
      switch      = string # on/off
      header_name = optional(string)
    }))
    client_ip_header = optional(object({
      switch      = string # on/off
      header_name = optional(string)
    }))
    compression = optional(object({
      switch     = string # on/off
      algorithms = optional(list(string), ["brotli", "gzip"])
    }))
    force_redirect_https = optional(object({
      switch               = string # on/off
      redirect_status_code = optional(number, 302)
    }))
    grpc = optional(object({
      switch = string # on/off
    }))
    hsts = optional(object({
      switch              = string # on/off
      include_sub_domains = optional(string, "off")
      preload             = optional(string, "off")
      timeout             = optional(number, 0)
    }))
    http2 = optional(object({
      switch = string # on/off
    }))
    ipv6 = optional(object({
      switch = string # on/off
    }))
    max_age = optional(object({
      follow_origin = optional(string, "on")
      cache_time    = optional(number, 600)
    }))
    ocsp_stapling = optional(object({
      switch = string # on/off
    }))
    offline_cache = optional(object({
      switch = string # on/off
    }))
    post_max_size = optional(object({
      switch   = string # on/off
      max_size = optional(number, 838860800)
    }))
    quic = optional(object({
      switch = string # on/off
    }))
    smart_routing = optional(object({
      switch = string # on/off
    }))
    standard_debug = optional(object({
      switch               = string # on/off
      allow_client_ip_list = optional(list(string), [])
      expires              = optional(string)
    }))
    tls_config = optional(object({
      cipher_suite = optional(string, "loose-v2023")
      version      = optional(list(string), ["TLSv1", "TLSv1.1", "TLSv1.2", "TLSv1.3"])
    }))
    upstream_http2 = optional(object({
      switch = string # on/off
    }))
    web_socket = optional(object({
      switch  = string # on/off
      timeout = optional(number, 30)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Description of the cluster."
  type        = map(string)
  default     = {}
}
