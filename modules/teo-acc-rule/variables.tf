###############################################################################
### EdgeOne Acceleration Rule variables
###############################################################################
variable "edgeone_zone_id" {
  description = "ID of EdgeOne zone"
  type        = string
}

variable "acc_rule" {
  description = "Acceleration rule list."
  type = object({
    name        = optional(string)           # Rule name. The name length limit is 255 characters.
    description = optional(list(string))     # Rule annotation. Multiple annotations can be added.
    status      = optional(string, "enable") # Rule status. Valid values: enable, disable.
  })
}

variable "branches" {
  description = "Rule branch list. Currently supports filling in only one branch."
  type = list(object({
    condition = string # Match condition. Refer to https://www.tencentcloud.com/document/product/1145/54759
    actions = optional(list(object({
      name = string # Operation name. Must correspond to the parameter structure.

      # Node cache TTL configuration
      cache_parameters = optional(object({
        custom_time = optional(object({
          cache_time           = optional(number, 2592000) # Custom cache time value in seconds. Range: 0-315360000.
          ignore_cache_control = optional(string, "off")   # Ignore origin server cache-control switch. Values: on/off.
          switch               = string                    # Custom cache time switch. Values: on/off.
        }))
        follow_origin = optional(object({
          switch                 = string                  # Whether to enable follow origin. Values: on/off.
          default_cache          = optional(string, "off") # Whether to cache when origin does not return cache-control. Values: On/Off.
          default_cache_strategy = optional(string, "on")  # Whether to use default caching policy. Values: on/off.
          default_cache_time     = optional(number, 0)     # Default cache time in seconds. Range: 0-315360000.
        }))
        no_cache = optional(object({
          switch = string # Whether to enable no-cache. Values: on/off.
        }))
      }))

      # Custom Cache Key configuration
      cache_key_parameters = optional(object({
        full_url_cache = optional(string, "on")  # Switch for retaining the complete query string. Values: on/off.
        ignore_case    = optional(string, "off") # Switch for ignoring case. Values: on/off.
        scheme         = optional(string)        # Request protocol switch. Values: on/off.
        query_string = optional(object({
          action = optional(string)        # Actions for query string parameters. Values: includeCustom/excludeCustom.
          switch = optional(string, "off") # Query string switch. Values: on/off.
          values = optional(list(string))  # Parameter names list.
        }))
        header = optional(object({
          switch = optional(string, "off") # Whether to enable feature. Values: on/off.
          values = optional(list(string))  # Custom cache key HTTP request header list.
        }))
        cookie = optional(object({
          action = optional(string)        # Cache action. Values: full/ignore/includeCustom/excludeCustom.
          switch = optional(string, "off") # Whether to enable feature. Values: on/off.
          values = optional(list(string))  # Custom cache key cookie name list.
        }))
      }))

      # Cache pre-refresh configuration
      cache_prefresh_parameters = optional(object({
        switch             = string               # Whether to enable cache prefresh. Values: on/off.
        cache_time_percent = optional(number, 90) # Prefresh interval as percentage of node cache time. Range: 1-99.
      }))

      # Access URL redirection configuration
      access_url_redirect_parameters = optional(object({
        status_code = optional(number) # Status code. Values: 301, 302, 303, 307, 308.
        protocol    = optional(string) # Target request protocol. Values: http/https/follow.
        host_name = optional(object({
          action = optional(string) # Target hostname configuration. Values: follow/custom.
          value  = optional(string) # Custom value for target hostname.
        }))
        url_path = optional(object({
          action = optional(string) # Action. Values: follow/custom/regex.
          value  = optional(string) # Redirect target URL.
          regex  = optional(string) # Regular expression matching expression.
        }))
        query_string = optional(object({
          action = optional(string) # Action. Values: full/ignore.
        }))
      }))

      # Back-to-origin URL rewrite configuration
      upstream_url_rewrite_parameters = optional(object({
        type   = optional(string) # Rewriting type, only path is supported.
        action = optional(string) # Action. Values: replace/addPrefix/rmvPrefix.
        value  = optional(string) # Rewrite value, max length 1024, must start with /.
        regex  = optional(string) # Regular expression for matching the complete path.
      }))

      # QUIC configuration
      quic_parameters = optional(object({
        switch = string # Whether to enable QUIC. Values: on/off.
      }))

      # WebSocket configuration
      web_socket_parameters = optional(object({
        switch  = string               # Whether to enable WebSocket. Values: on/off.
        timeout = optional(number, 30) # Timeout in seconds. Max: 120.
      }))

      # Token authentication configuration
      authentication_parameters = optional(object({
        auth_type         = optional(string) # Authentication type. Values: TypeA/TypeB/TypeC/TypeD/TypeVOD.
        secret_key        = optional(string) # Primary authentication key. 6-40 chars.
        backup_secret_key = optional(string) # Backup authentication key. 6-40 chars.
        timeout           = optional(number) # Validity period in seconds. Range: 1-630720000.
        time_format       = optional(string) # Authentication time format. Values: dec/hex.
        time_param        = optional(string) # Authentication timestamp.
        auth_param        = optional(string) # Authentication parameter name.
      }))

      # Browser cache TTL configuration
      max_age_parameters = optional(object({
        follow_origin = optional(string, "on") # Whether to follow origin server cache-control. Values: on/off.
        cache_time    = optional(number, 600)  # Custom cache time in seconds. Range: 0-315360000.
      }))

      # Status code cache TTL configuration
      status_code_cache_parameters = optional(object({
        status_code_cache_params = optional(list(object({
          status_code = optional(number) # Status code. Values: 400, 401, 403, 404, 405, 407, 414, 500, 501, 502, 503, 504, 509, 514.
          cache_time  = optional(number) # Cache time in seconds. Range: 0-31536000.
        })))
      }))

      # Offline cache configuration
      offline_cache_parameters = optional(object({
        switch = string # Whether to enable offline caching. Values: on/off.
      }))

      # Smart acceleration configuration
      smart_routing_parameters = optional(object({
        switch = string # Whether to enable smart acceleration. Values: on/off.
      }))

      # Range origin pull configuration
      range_origin_pull_parameters = optional(object({
        switch = string # Whether to enable range gets. Values: on/off.
      }))

      # HTTP2 origin-pull configuration
      upstream_http2_parameters = optional(object({
        switch = string # Whether to enable HTTP2 origin-pull. Values: on/off.
      }))

      # Host Header rewrite configuration
      host_header_parameters = optional(object({
        action      = optional(string) # Action. Values: followOrigin/custom.
        server_name = optional(string) # Host header rewrite value, requires a complete domain name.
      }))

      # Force HTTPS redirect configuration
      force_redirect_https_parameters = optional(object({
        switch               = string                # Whether to enable forced redirect. Values: on/off.
        redirect_status_code = optional(number, 302) # Redirection status code. Values: 301/302.
      }))

      # Back-to-origin HTTPS configuration
      origin_pull_protocol_parameters = optional(object({
        protocol = optional(string) # Back-to-origin protocol. Values: http/https/follow.
      }))

      # Smart compression configuration
      compression_parameters = optional(object({
        switch     = string                                     # Whether to enable smart compression. Values: on/off.
        algorithms = optional(list(string), ["brotli", "gzip"]) # Compression algorithm list. Values: brotli/gzip.
      }))

      # Content compression configuration
      content_compression_parameters = optional(object({
        switch = string # Content compression switch. Values: on/off.
      }))

      # HSTS configuration
      hsts_parameters = optional(object({
        switch              = string                  # Whether to enable HSTS. Values: on/off.
        timeout             = optional(number, 0)     # Cache HSTS header time in seconds. Range: 1-31536000.
        include_sub_domains = optional(string, "off") # Whether to allow subdomains to inherit. Values: on/off.
        preload             = optional(string, "off") # Whether to allow browser to preload. Values: on/off.
      }))

      # Client IP header configuration
      client_ip_header_parameters = optional(object({
        switch      = string           # Whether to enable. Values: on/off.
        header_name = optional(string) # Name of the request header containing client IP.
      }))

      # OCSP stapling configuration
      ocsp_stapling_parameters = optional(object({
        switch = string # Whether to enable OCSP stapling. Values: on/off.
      }))

      # HTTP2 access configuration
      http2_parameters = optional(object({
        switch = string # Whether to enable HTTP2 access. Values: on/off.
      }))

      # POST request upload file size limit configuration
      post_max_size_parameters = optional(object({
        switch   = string                      # Whether to enable limit. Values: on/off.
        max_size = optional(number, 838860800) # Maximum size in bytes. Range: 1*2^20 to 500*2^20.
      }))

      # Client IP country configuration
      client_ip_country_parameters = optional(object({
        switch      = string           # Whether to enable. Values: on/off.
        header_name = optional(string) # Name of the request header for client IP region.
      }))

      # Origin-pull follow redirect configuration
      upstream_follow_redirect_parameters = optional(object({
        switch    = string              # Whether to enable. Values: on/off.
        max_times = optional(number, 3) # Maximum number of redirects. Range: 1-5.
      }))

      # Origin-pull request parameters configuration
      upstream_request_parameters = optional(object({
        query_string = optional(object({
          action = optional(string)        # Query string mode. Values: full/ignore/includeCustom/excludeCustom.
          switch = optional(string, "off") # Whether to enable. Values: on/off.
          values = optional(list(string))  # Parameter values list.
        }))
        cookie = optional(object({
          action = optional(string)        # Cookie mode. Values: full/ignore/includeCustom/excludeCustom.
          switch = optional(string, "off") # Whether to enable. Values: on/off.
          values = optional(list(string))  # Parameter values list.
        }))
      }))

      # SSL/TLS security configuration
      tls_config_parameters = optional(object({
        cipher_suite = optional(string, "loose-v2023")                                    # Cipher suite. Values: loose-v2023/general-v2023/strict-v2023.
        version      = optional(list(string), ["TLSv1", "TLSv1.1", "TLSv1.2", "TLSv1.3"]) # TLS version list.
      }))

      # Modify origin server configuration
      modify_origin_parameters = optional(object({
        origin_type       = optional(string) # Origin type. Values: IPDomain/OriginGroup/LoadBalance/COS/AWSS3.
        origin            = optional(string) # Origin server address.
        origin_protocol   = optional(string) # Origin-pull protocol. Values: Http/Https/Follow.
        http_origin_port  = optional(number) # HTTP origin-pull port. Range: 1-65535.
        https_origin_port = optional(number) # HTTPS origin-pull port. Range: 1-65535.
        private_access    = optional(string) # Whether to enable private authentication. Values: on/off.
        private_parameters = optional(object({
          access_key_id     = string           # Access Key ID.
          secret_access_key = string           # Secret Access Key.
          signature_version = string           # Signature version. Values: v2/v4.
          region            = optional(string) # Region of the bucket.
        }))
      }))

      # Layer 7 origin timeout configuration
      http_upstream_timeout_parameters = optional(object({
        response_timeout = optional(number) # HTTP response timeout in seconds. Range: 5-600.
      }))

      # HTTP response configuration
      http_response_parameters = optional(object({
        status_code   = optional(number) # Response status code.
        response_page = optional(string) # Response page ID.
      }))

      # Custom error page configuration
      error_page_parameters = optional(object({
        error_page_params = optional(list(object({
          status_code  = number # Status code. Values: 400, 403, 404, 405, 414, 416, 451, 500, 501, 502, 503, 504.
          redirect_url = string # Redirect URL, requires a full path.
        })))
      }))

      # Modify HTTP node response header configuration
      modify_response_header_parameters = optional(object({
        header_actions = optional(list(object({
          action = string           # Action. Values: set/del/add.
          name   = string           # HTTP header name.
          value  = optional(string) # HTTP header value.
        })))
      }))

      # Modify HTTP node request header configuration
      modify_request_header_parameters = optional(object({
        header_actions = optional(list(object({
          action = string           # Action. Values: set/del/add.
          name   = string           # HTTP header name.
          value  = optional(string) # HTTP header value.
        })))
      }))

      # Single connection download speed limit configuration
      response_speed_limit_parameters = optional(object({
        mode      = string           # Download rate limit mode. Values: LimitUponDownload/LimitAfterSpecificBytesDownloaded/LimitAfterSpecificSecondsDownloaded.
        max_speed = string           # Rate-limiting value in kb/s.
        start_at  = optional(string) # Rate-limiting start value in kb or s.
      }))

      # Content identifier configuration
      set_content_identifier_parameters = optional(object({
        content_identifier = optional(string) # Content identifier ID.
      }))
    })), [])

    sub_rules = optional(list(object({
      description = optional(list(string)) # Sub-rule comments.
      branches = list(object({
        condition = string # Match condition.
        actions = optional(list(object({
          name = string # Operation name.

          cache_parameters = optional(object({
            custom_time = optional(object({
              cache_time           = optional(number, 2592000)
              ignore_cache_control = optional(string, "off")
              switch               = string
            }))
            follow_origin = optional(object({
              switch                 = string
              default_cache          = optional(string, "off")
              default_cache_strategy = optional(string, "on")
              default_cache_time     = optional(number, 0)
            }))
            no_cache = optional(object({
              switch = string
            }))
          }))

          cache_key_parameters = optional(object({
            full_url_cache = optional(string, "on")
            ignore_case    = optional(string, "off")
            scheme         = optional(string)
            query_string = optional(object({
              action = optional(string)
              switch = optional(string, "off")
              values = optional(list(string))
            }))
            header = optional(object({
              switch = optional(string, "off")
              values = optional(list(string))
            }))
            cookie = optional(object({
              action = optional(string)
              switch = optional(string, "off")
              values = optional(list(string))
            }))
          }))

          cache_prefresh_parameters = optional(object({
            switch             = string
            cache_time_percent = optional(number, 90)
          }))

          access_url_redirect_parameters = optional(object({
            status_code = optional(number)
            protocol    = optional(string)
            host_name = optional(object({
              action = optional(string)
              value  = optional(string)
            }))
            url_path = optional(object({
              action = optional(string)
              value  = optional(string)
              regex  = optional(string)
            }))
            query_string = optional(object({
              action = optional(string)
            }))
          }))

          upstream_url_rewrite_parameters = optional(object({
            type   = optional(string)
            action = optional(string)
            value  = optional(string)
            regex  = optional(string)
          }))

          quic_parameters = optional(object({
            switch = string
          }))

          web_socket_parameters = optional(object({
            switch  = string
            timeout = optional(number, 30)
          }))

          authentication_parameters = optional(object({
            auth_type         = optional(string)
            secret_key        = optional(string)
            backup_secret_key = optional(string)
            timeout           = optional(number)
            time_format       = optional(string)
            time_param        = optional(string)
            auth_param        = optional(string)
          }))

          max_age_parameters = optional(object({
            follow_origin = optional(string, "on")
            cache_time    = optional(number, 600)
          }))

          status_code_cache_parameters = optional(object({
            status_code_cache_params = optional(list(object({
              status_code = optional(number)
              cache_time  = optional(number)
            })))
          }))

          offline_cache_parameters = optional(object({
            switch = string
          }))

          smart_routing_parameters = optional(object({
            switch = string
          }))

          range_origin_pull_parameters = optional(object({
            switch = string
          }))

          upstream_http2_parameters = optional(object({
            switch = string
          }))

          host_header_parameters = optional(object({
            action      = optional(string)
            server_name = optional(string)
          }))

          force_redirect_https_parameters = optional(object({
            switch               = string
            redirect_status_code = optional(number, 302)
          }))

          origin_pull_protocol_parameters = optional(object({
            protocol = optional(string)
          }))

          compression_parameters = optional(object({
            switch     = string
            algorithms = optional(list(string), ["brotli", "gzip"])
          }))

          content_compression_parameters = optional(object({
            switch = string
          }))

          hsts_parameters = optional(object({
            switch              = string
            timeout             = optional(number, 0)
            include_sub_domains = optional(string, "off")
            preload             = optional(string, "off")
          }))

          client_ip_header_parameters = optional(object({
            switch      = string
            header_name = optional(string)
          }))

          ocsp_stapling_parameters = optional(object({
            switch = string
          }))

          http2_parameters = optional(object({
            switch = string
          }))

          post_max_size_parameters = optional(object({
            switch   = string
            max_size = optional(number, 838860800)
          }))

          client_ip_country_parameters = optional(object({
            switch      = string
            header_name = optional(string)
          }))

          upstream_follow_redirect_parameters = optional(object({
            switch    = string
            max_times = optional(number, 3)
          }))

          upstream_request_parameters = optional(object({
            query_string = optional(object({
              action = optional(string)
              switch = optional(string, "off")
              values = optional(list(string))
            }))
            cookie = optional(object({
              action = optional(string)
              switch = optional(string, "off")
              values = optional(list(string))
            }))
          }))

          tls_config_parameters = optional(object({
            cipher_suite = optional(string, "loose-v2023")
            version      = optional(list(string), ["TLSv1", "TLSv1.1", "TLSv1.2", "TLSv1.3"])
          }))

          modify_origin_parameters = optional(object({
            origin_type       = optional(string)
            origin            = optional(string)
            origin_protocol   = optional(string)
            http_origin_port  = optional(number)
            https_origin_port = optional(number)
            private_access    = optional(string)
            private_parameters = optional(object({
              access_key_id     = string
              secret_access_key = string
              signature_version = string
              region            = optional(string)
            }))
          }))

          http_upstream_timeout_parameters = optional(object({
            response_timeout = optional(number)
          }))

          http_response_parameters = optional(object({
            status_code   = optional(number)
            response_page = optional(string)
          }))

          error_page_parameters = optional(object({
            error_page_params = optional(list(object({
              status_code  = number
              redirect_url = string
            })))
          }))

          modify_response_header_parameters = optional(object({
            header_actions = optional(list(object({
              action = string
              name   = string
              value  = optional(string)
            })))
          }))

          modify_request_header_parameters = optional(object({
            header_actions = optional(list(object({
              action = string
              name   = string
              value  = optional(string)
            })))
          }))

          response_speed_limit_parameters = optional(object({
            mode      = string
            max_speed = string
            start_at  = optional(string)
          }))

          set_content_identifier_parameters = optional(object({
            content_identifier = optional(string)
          }))
        })), [])
      }))
    })), [])
  }))
  default = []
}
