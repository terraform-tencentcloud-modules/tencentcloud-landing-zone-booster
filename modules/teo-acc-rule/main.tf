###############################################################################
### EdgeOne L7 Acceleration Rule V2 resource
###############################################################################
resource "tencentcloud_teo_l7_acc_rule_v2" "acc_rule" {
  zone_id     = var.edgeone_zone_id
  rule_name   = var.acc_rule.name
  description = var.acc_rule.description
  status      = var.acc_rule.status

  dynamic "branches" {
    for_each = var.branches
    content {
      condition = branches.value.condition

      dynamic "actions" {
        for_each = branches.value.actions != null ? branches.value.actions : []
        content {
          name = actions.value.name

          # Node cache TTL
          dynamic "cache_parameters" {
            for_each = actions.value.cache_parameters != null ? [actions.value.cache_parameters] : []
            content {
              dynamic "custom_time" {
                for_each = cache_parameters.value.custom_time != null ? [cache_parameters.value.custom_time] : []
                content {
                  cache_time           = custom_time.value.cache_time
                  ignore_cache_control = custom_time.value.ignore_cache_control
                  switch               = custom_time.value.switch
                }
              }
              dynamic "follow_origin" {
                for_each = cache_parameters.value.follow_origin != null ? [cache_parameters.value.follow_origin] : []
                content {
                  switch                 = follow_origin.value.switch
                  default_cache          = follow_origin.value.default_cache
                  default_cache_strategy = follow_origin.value.default_cache_strategy
                  default_cache_time     = follow_origin.value.default_cache_time
                }
              }
              dynamic "no_cache" {
                for_each = cache_parameters.value.no_cache != null ? [cache_parameters.value.no_cache] : []
                content {
                  switch = no_cache.value.switch
                }
              }
            }
          }

          # Custom Cache Key
          dynamic "cache_key_parameters" {
            for_each = actions.value.cache_key_parameters != null ? [actions.value.cache_key_parameters] : []
            content {
              full_url_cache = cache_key_parameters.value.full_url_cache
              ignore_case    = cache_key_parameters.value.ignore_case
              scheme         = cache_key_parameters.value.scheme
              dynamic "query_string" {
                for_each = cache_key_parameters.value.query_string != null ? [cache_key_parameters.value.query_string] : []
                content {
                  action = query_string.value.action
                  switch = query_string.value.switch
                  values = query_string.value.values
                }
              }
              dynamic "header" {
                for_each = cache_key_parameters.value.header != null ? [cache_key_parameters.value.header] : []
                content {
                  switch = header.value.switch
                  values = header.value.values
                }
              }
              dynamic "cookie" {
                for_each = cache_key_parameters.value.cookie != null ? [cache_key_parameters.value.cookie] : []
                content {
                  action = cookie.value.action
                  switch = cookie.value.switch
                  values = cookie.value.values
                }
              }
            }
          }

          # Cache pre-refresh
          dynamic "cache_prefresh_parameters" {
            for_each = actions.value.cache_prefresh_parameters != null ? [actions.value.cache_prefresh_parameters] : []
            content {
              switch             = cache_prefresh_parameters.value.switch
              cache_time_percent = cache_prefresh_parameters.value.cache_time_percent
            }
          }

          # Access URL redirection
          dynamic "access_url_redirect_parameters" {
            for_each = actions.value.access_url_redirect_parameters != null ? [actions.value.access_url_redirect_parameters] : []
            content {
              status_code = access_url_redirect_parameters.value.status_code
              protocol    = access_url_redirect_parameters.value.protocol
              dynamic "host_name" {
                for_each = access_url_redirect_parameters.value.host_name != null ? [access_url_redirect_parameters.value.host_name] : []
                content {
                  action = host_name.value.action
                  value  = host_name.value.value
                }
              }
              dynamic "url_path" {
                for_each = access_url_redirect_parameters.value.url_path != null ? [access_url_redirect_parameters.value.url_path] : []
                content {
                  action = url_path.value.action
                  value  = url_path.value.value
                  regex  = url_path.value.regex
                }
              }
              dynamic "query_string" {
                for_each = access_url_redirect_parameters.value.query_string != null ? [access_url_redirect_parameters.value.query_string] : []
                content {
                  action = query_string.value.action
                }
              }
            }
          }

          # Back-to-origin URL rewrite
          dynamic "upstream_url_rewrite_parameters" {
            for_each = actions.value.upstream_url_rewrite_parameters != null ? [actions.value.upstream_url_rewrite_parameters] : []
            content {
              type   = upstream_url_rewrite_parameters.value.type
              action = upstream_url_rewrite_parameters.value.action
              value  = upstream_url_rewrite_parameters.value.value
              regex  = upstream_url_rewrite_parameters.value.regex
            }
          }

          # QUIC
          dynamic "quic_parameters" {
            for_each = actions.value.quic_parameters != null ? [actions.value.quic_parameters] : []
            content {
              switch = quic_parameters.value.switch
            }
          }

          # WebSocket
          dynamic "web_socket_parameters" {
            for_each = actions.value.web_socket_parameters != null ? [actions.value.web_socket_parameters] : []
            content {
              switch  = web_socket_parameters.value.switch
              timeout = web_socket_parameters.value.timeout
            }
          }

          # Token authentication
          dynamic "authentication_parameters" {
            for_each = actions.value.authentication_parameters != null ? [actions.value.authentication_parameters] : []
            content {
              auth_type         = authentication_parameters.value.auth_type
              secret_key        = authentication_parameters.value.secret_key
              backup_secret_key = authentication_parameters.value.backup_secret_key
              timeout           = authentication_parameters.value.timeout
              time_format       = authentication_parameters.value.time_format
              time_param        = authentication_parameters.value.time_param
              auth_param        = authentication_parameters.value.auth_param
            }
          }

          # Browser cache TTL
          dynamic "max_age_parameters" {
            for_each = actions.value.max_age_parameters != null ? [actions.value.max_age_parameters] : []
            content {
              follow_origin = max_age_parameters.value.follow_origin
              cache_time    = max_age_parameters.value.cache_time
            }
          }

          # Status code cache TTL
          dynamic "status_code_cache_parameters" {
            for_each = actions.value.status_code_cache_parameters != null ? [actions.value.status_code_cache_parameters] : []
            content {
              dynamic "status_code_cache_params" {
                for_each = status_code_cache_parameters.value.status_code_cache_params != null ? status_code_cache_parameters.value.status_code_cache_params : []
                content {
                  status_code = status_code_cache_params.value.status_code
                  cache_time  = status_code_cache_params.value.cache_time
                }
              }
            }
          }

          # Offline cache
          dynamic "offline_cache_parameters" {
            for_each = actions.value.offline_cache_parameters != null ? [actions.value.offline_cache_parameters] : []
            content {
              switch = offline_cache_parameters.value.switch
            }
          }

          # Smart acceleration
          dynamic "smart_routing_parameters" {
            for_each = actions.value.smart_routing_parameters != null ? [actions.value.smart_routing_parameters] : []
            content {
              switch = smart_routing_parameters.value.switch
            }
          }

          # Range origin pull
          dynamic "range_origin_pull_parameters" {
            for_each = actions.value.range_origin_pull_parameters != null ? [actions.value.range_origin_pull_parameters] : []
            content {
              switch = range_origin_pull_parameters.value.switch
            }
          }

          # HTTP2 origin-pull
          dynamic "upstream_http2_parameters" {
            for_each = actions.value.upstream_http2_parameters != null ? [actions.value.upstream_http2_parameters] : []
            content {
              switch = upstream_http2_parameters.value.switch
            }
          }

          # Host Header rewrite
          dynamic "host_header_parameters" {
            for_each = actions.value.host_header_parameters != null ? [actions.value.host_header_parameters] : []
            content {
              action      = host_header_parameters.value.action
              server_name = host_header_parameters.value.server_name
            }
          }

          # Force HTTPS redirect
          dynamic "force_redirect_https_parameters" {
            for_each = actions.value.force_redirect_https_parameters != null ? [actions.value.force_redirect_https_parameters] : []
            content {
              switch               = force_redirect_https_parameters.value.switch
              redirect_status_code = force_redirect_https_parameters.value.redirect_status_code
            }
          }

          # Back-to-origin HTTPS
          dynamic "origin_pull_protocol_parameters" {
            for_each = actions.value.origin_pull_protocol_parameters != null ? [actions.value.origin_pull_protocol_parameters] : []
            content {
              protocol = origin_pull_protocol_parameters.value.protocol
            }
          }

          # Smart compression
          dynamic "compression_parameters" {
            for_each = actions.value.compression_parameters != null ? [actions.value.compression_parameters] : []
            content {
              switch     = compression_parameters.value.switch
              algorithms = compression_parameters.value.algorithms
            }
          }

          # Content compression
          dynamic "content_compression_parameters" {
            for_each = actions.value.content_compression_parameters != null ? [actions.value.content_compression_parameters] : []
            content {
              switch = content_compression_parameters.value.switch
            }
          }

          # HSTS
          dynamic "hsts_parameters" {
            for_each = actions.value.hsts_parameters != null ? [actions.value.hsts_parameters] : []
            content {
              switch              = hsts_parameters.value.switch
              timeout             = hsts_parameters.value.timeout
              include_sub_domains = hsts_parameters.value.include_sub_domains
              preload             = hsts_parameters.value.preload
            }
          }

          # Client IP header
          dynamic "client_ip_header_parameters" {
            for_each = actions.value.client_ip_header_parameters != null ? [actions.value.client_ip_header_parameters] : []
            content {
              switch      = client_ip_header_parameters.value.switch
              header_name = client_ip_header_parameters.value.header_name
            }
          }

          # OCSP stapling
          dynamic "ocsp_stapling_parameters" {
            for_each = actions.value.ocsp_stapling_parameters != null ? [actions.value.ocsp_stapling_parameters] : []
            content {
              switch = ocsp_stapling_parameters.value.switch
            }
          }

          # HTTP2 access
          dynamic "http2_parameters" {
            for_each = actions.value.http2_parameters != null ? [actions.value.http2_parameters] : []
            content {
              switch = http2_parameters.value.switch
            }
          }

          # POST request upload file size limit
          dynamic "post_max_size_parameters" {
            for_each = actions.value.post_max_size_parameters != null ? [actions.value.post_max_size_parameters] : []
            content {
              switch   = post_max_size_parameters.value.switch
              max_size = post_max_size_parameters.value.max_size
            }
          }

          # Client IP country
          dynamic "client_ip_country_parameters" {
            for_each = actions.value.client_ip_country_parameters != null ? [actions.value.client_ip_country_parameters] : []
            content {
              switch      = client_ip_country_parameters.value.switch
              header_name = client_ip_country_parameters.value.header_name
            }
          }

          # Origin-pull follow redirect
          dynamic "upstream_follow_redirect_parameters" {
            for_each = actions.value.upstream_follow_redirect_parameters != null ? [actions.value.upstream_follow_redirect_parameters] : []
            content {
              switch    = upstream_follow_redirect_parameters.value.switch
              max_times = upstream_follow_redirect_parameters.value.max_times
            }
          }

          # Origin-pull request parameters
          dynamic "upstream_request_parameters" {
            for_each = actions.value.upstream_request_parameters != null ? [actions.value.upstream_request_parameters] : []
            content {
              dynamic "query_string" {
                for_each = upstream_request_parameters.value.query_string != null ? [upstream_request_parameters.value.query_string] : []
                content {
                  action = query_string.value.action
                  switch = query_string.value.switch
                  values = query_string.value.values
                }
              }
              dynamic "cookie" {
                for_each = upstream_request_parameters.value.cookie != null ? [upstream_request_parameters.value.cookie] : []
                content {
                  action = cookie.value.action
                  switch = cookie.value.switch
                  values = cookie.value.values
                }
              }
            }
          }

          # SSL/TLS security
          dynamic "tls_config_parameters" {
            for_each = actions.value.tls_config_parameters != null ? [actions.value.tls_config_parameters] : []
            content {
              cipher_suite = tls_config_parameters.value.cipher_suite
              version      = tls_config_parameters.value.version
            }
          }

          # Modify origin server
          dynamic "modify_origin_parameters" {
            for_each = actions.value.modify_origin_parameters != null ? [actions.value.modify_origin_parameters] : []
            content {
              origin_type       = modify_origin_parameters.value.origin_type
              origin            = modify_origin_parameters.value.origin
              origin_protocol   = modify_origin_parameters.value.origin_protocol
              http_origin_port  = modify_origin_parameters.value.http_origin_port
              https_origin_port = modify_origin_parameters.value.https_origin_port
              private_access    = modify_origin_parameters.value.private_access
              dynamic "private_parameters" {
                for_each = modify_origin_parameters.value.private_parameters != null ? [modify_origin_parameters.value.private_parameters] : []
                content {
                  access_key_id     = private_parameters.value.access_key_id
                  secret_access_key = private_parameters.value.secret_access_key
                  signature_version = private_parameters.value.signature_version
                  region            = private_parameters.value.region
                }
              }
            }
          }

          # Layer 7 origin timeout
          dynamic "http_upstream_timeout_parameters" {
            for_each = actions.value.http_upstream_timeout_parameters != null ? [actions.value.http_upstream_timeout_parameters] : []
            content {
              response_timeout = http_upstream_timeout_parameters.value.response_timeout
            }
          }

          # HTTP response
          dynamic "http_response_parameters" {
            for_each = actions.value.http_response_parameters != null ? [actions.value.http_response_parameters] : []
            content {
              status_code   = http_response_parameters.value.status_code
              response_page = http_response_parameters.value.response_page
            }
          }

          # Custom error page
          dynamic "error_page_parameters" {
            for_each = actions.value.error_page_parameters != null ? [actions.value.error_page_parameters] : []
            content {
              dynamic "error_page_params" {
                for_each = error_page_parameters.value.error_page_params != null ? error_page_parameters.value.error_page_params : []
                content {
                  status_code  = error_page_params.value.status_code
                  redirect_url = error_page_params.value.redirect_url
                }
              }
            }
          }

          # Modify HTTP node response header
          dynamic "modify_response_header_parameters" {
            for_each = actions.value.modify_response_header_parameters != null ? [actions.value.modify_response_header_parameters] : []
            content {
              dynamic "header_actions" {
                for_each = modify_response_header_parameters.value.header_actions != null ? modify_response_header_parameters.value.header_actions : []
                content {
                  action = header_actions.value.action
                  name   = header_actions.value.name
                  value  = header_actions.value.value
                }
              }
            }
          }

          # Modify HTTP node request header
          dynamic "modify_request_header_parameters" {
            for_each = actions.value.modify_request_header_parameters != null ? [actions.value.modify_request_header_parameters] : []
            content {
              dynamic "header_actions" {
                for_each = modify_request_header_parameters.value.header_actions != null ? modify_request_header_parameters.value.header_actions : []
                content {
                  action = header_actions.value.action
                  name   = header_actions.value.name
                  value  = header_actions.value.value
                }
              }
            }
          }

          # Single connection download speed limit
          dynamic "response_speed_limit_parameters" {
            for_each = actions.value.response_speed_limit_parameters != null ? [actions.value.response_speed_limit_parameters] : []
            content {
              mode      = response_speed_limit_parameters.value.mode
              max_speed = response_speed_limit_parameters.value.max_speed
              start_at  = response_speed_limit_parameters.value.start_at
            }
          }

          # Content identifier
          dynamic "set_content_identifier_parameters" {
            for_each = actions.value.set_content_identifier_parameters != null ? [actions.value.set_content_identifier_parameters] : []
            content {
              content_identifier = set_content_identifier_parameters.value.content_identifier
            }
          }
        }
      }

      ###########################################################################
      ### Sub-rules
      ###########################################################################
      dynamic "sub_rules" {
        for_each = branches.value.sub_rules != null ? branches.value.sub_rules : []
        content {
          description = sub_rules.value.description

          dynamic "branches" {
            for_each = sub_rules.value.branches
            content {
              condition = branches.value.condition

              dynamic "actions" {
                for_each = branches.value.actions != null ? branches.value.actions : []
                content {
                  name = actions.value.name

                  dynamic "cache_parameters" {
                    for_each = actions.value.cache_parameters != null ? [actions.value.cache_parameters] : []
                    content {
                      dynamic "custom_time" {
                        for_each = cache_parameters.value.custom_time != null ? [cache_parameters.value.custom_time] : []
                        content {
                          cache_time           = custom_time.value.cache_time
                          ignore_cache_control = custom_time.value.ignore_cache_control
                          switch               = custom_time.value.switch
                        }
                      }
                      dynamic "follow_origin" {
                        for_each = cache_parameters.value.follow_origin != null ? [cache_parameters.value.follow_origin] : []
                        content {
                          switch                 = follow_origin.value.switch
                          default_cache          = follow_origin.value.default_cache
                          default_cache_strategy = follow_origin.value.default_cache_strategy
                          default_cache_time     = follow_origin.value.default_cache_time
                        }
                      }
                      dynamic "no_cache" {
                        for_each = cache_parameters.value.no_cache != null ? [cache_parameters.value.no_cache] : []
                        content {
                          switch = no_cache.value.switch
                        }
                      }
                    }
                  }

                  dynamic "cache_key_parameters" {
                    for_each = actions.value.cache_key_parameters != null ? [actions.value.cache_key_parameters] : []
                    content {
                      full_url_cache = cache_key_parameters.value.full_url_cache
                      ignore_case    = cache_key_parameters.value.ignore_case
                      scheme         = cache_key_parameters.value.scheme
                      dynamic "query_string" {
                        for_each = cache_key_parameters.value.query_string != null ? [cache_key_parameters.value.query_string] : []
                        content {
                          action = query_string.value.action
                          switch = query_string.value.switch
                          values = query_string.value.values
                        }
                      }
                      dynamic "header" {
                        for_each = cache_key_parameters.value.header != null ? [cache_key_parameters.value.header] : []
                        content {
                          switch = header.value.switch
                          values = header.value.values
                        }
                      }
                      dynamic "cookie" {
                        for_each = cache_key_parameters.value.cookie != null ? [cache_key_parameters.value.cookie] : []
                        content {
                          action = cookie.value.action
                          switch = cookie.value.switch
                          values = cookie.value.values
                        }
                      }
                    }
                  }

                  dynamic "cache_prefresh_parameters" {
                    for_each = actions.value.cache_prefresh_parameters != null ? [actions.value.cache_prefresh_parameters] : []
                    content {
                      switch             = cache_prefresh_parameters.value.switch
                      cache_time_percent = cache_prefresh_parameters.value.cache_time_percent
                    }
                  }

                  dynamic "access_url_redirect_parameters" {
                    for_each = actions.value.access_url_redirect_parameters != null ? [actions.value.access_url_redirect_parameters] : []
                    content {
                      status_code = access_url_redirect_parameters.value.status_code
                      protocol    = access_url_redirect_parameters.value.protocol
                      dynamic "host_name" {
                        for_each = access_url_redirect_parameters.value.host_name != null ? [access_url_redirect_parameters.value.host_name] : []
                        content {
                          action = host_name.value.action
                          value  = host_name.value.value
                        }
                      }
                      dynamic "url_path" {
                        for_each = access_url_redirect_parameters.value.url_path != null ? [access_url_redirect_parameters.value.url_path] : []
                        content {
                          action = url_path.value.action
                          value  = url_path.value.value
                          regex  = url_path.value.regex
                        }
                      }
                      dynamic "query_string" {
                        for_each = access_url_redirect_parameters.value.query_string != null ? [access_url_redirect_parameters.value.query_string] : []
                        content {
                          action = query_string.value.action
                        }
                      }
                    }
                  }

                  dynamic "upstream_url_rewrite_parameters" {
                    for_each = actions.value.upstream_url_rewrite_parameters != null ? [actions.value.upstream_url_rewrite_parameters] : []
                    content {
                      type   = upstream_url_rewrite_parameters.value.type
                      action = upstream_url_rewrite_parameters.value.action
                      value  = upstream_url_rewrite_parameters.value.value
                      regex  = upstream_url_rewrite_parameters.value.regex
                    }
                  }

                  dynamic "quic_parameters" {
                    for_each = actions.value.quic_parameters != null ? [actions.value.quic_parameters] : []
                    content {
                      switch = quic_parameters.value.switch
                    }
                  }

                  dynamic "web_socket_parameters" {
                    for_each = actions.value.web_socket_parameters != null ? [actions.value.web_socket_parameters] : []
                    content {
                      switch  = web_socket_parameters.value.switch
                      timeout = web_socket_parameters.value.timeout
                    }
                  }

                  dynamic "authentication_parameters" {
                    for_each = actions.value.authentication_parameters != null ? [actions.value.authentication_parameters] : []
                    content {
                      auth_type         = authentication_parameters.value.auth_type
                      secret_key        = authentication_parameters.value.secret_key
                      backup_secret_key = authentication_parameters.value.backup_secret_key
                      timeout           = authentication_parameters.value.timeout
                      time_format       = authentication_parameters.value.time_format
                      time_param        = authentication_parameters.value.time_param
                      auth_param        = authentication_parameters.value.auth_param
                    }
                  }

                  dynamic "max_age_parameters" {
                    for_each = actions.value.max_age_parameters != null ? [actions.value.max_age_parameters] : []
                    content {
                      follow_origin = max_age_parameters.value.follow_origin
                      cache_time    = max_age_parameters.value.cache_time
                    }
                  }

                  dynamic "status_code_cache_parameters" {
                    for_each = actions.value.status_code_cache_parameters != null ? [actions.value.status_code_cache_parameters] : []
                    content {
                      dynamic "status_code_cache_params" {
                        for_each = status_code_cache_parameters.value.status_code_cache_params != null ? status_code_cache_parameters.value.status_code_cache_params : []
                        content {
                          status_code = status_code_cache_params.value.status_code
                          cache_time  = status_code_cache_params.value.cache_time
                        }
                      }
                    }
                  }

                  dynamic "offline_cache_parameters" {
                    for_each = actions.value.offline_cache_parameters != null ? [actions.value.offline_cache_parameters] : []
                    content {
                      switch = offline_cache_parameters.value.switch
                    }
                  }

                  dynamic "smart_routing_parameters" {
                    for_each = actions.value.smart_routing_parameters != null ? [actions.value.smart_routing_parameters] : []
                    content {
                      switch = smart_routing_parameters.value.switch
                    }
                  }

                  dynamic "range_origin_pull_parameters" {
                    for_each = actions.value.range_origin_pull_parameters != null ? [actions.value.range_origin_pull_parameters] : []
                    content {
                      switch = range_origin_pull_parameters.value.switch
                    }
                  }

                  dynamic "upstream_http2_parameters" {
                    for_each = actions.value.upstream_http2_parameters != null ? [actions.value.upstream_http2_parameters] : []
                    content {
                      switch = upstream_http2_parameters.value.switch
                    }
                  }

                  dynamic "host_header_parameters" {
                    for_each = actions.value.host_header_parameters != null ? [actions.value.host_header_parameters] : []
                    content {
                      action      = host_header_parameters.value.action
                      server_name = host_header_parameters.value.server_name
                    }
                  }

                  dynamic "force_redirect_https_parameters" {
                    for_each = actions.value.force_redirect_https_parameters != null ? [actions.value.force_redirect_https_parameters] : []
                    content {
                      switch               = force_redirect_https_parameters.value.switch
                      redirect_status_code = force_redirect_https_parameters.value.redirect_status_code
                    }
                  }

                  dynamic "origin_pull_protocol_parameters" {
                    for_each = actions.value.origin_pull_protocol_parameters != null ? [actions.value.origin_pull_protocol_parameters] : []
                    content {
                      protocol = origin_pull_protocol_parameters.value.protocol
                    }
                  }

                  dynamic "compression_parameters" {
                    for_each = actions.value.compression_parameters != null ? [actions.value.compression_parameters] : []
                    content {
                      switch     = compression_parameters.value.switch
                      algorithms = compression_parameters.value.algorithms
                    }
                  }

                  dynamic "content_compression_parameters" {
                    for_each = actions.value.content_compression_parameters != null ? [actions.value.content_compression_parameters] : []
                    content {
                      switch = content_compression_parameters.value.switch
                    }
                  }

                  dynamic "hsts_parameters" {
                    for_each = actions.value.hsts_parameters != null ? [actions.value.hsts_parameters] : []
                    content {
                      switch              = hsts_parameters.value.switch
                      timeout             = hsts_parameters.value.timeout
                      include_sub_domains = hsts_parameters.value.include_sub_domains
                      preload             = hsts_parameters.value.preload
                    }
                  }

                  dynamic "client_ip_header_parameters" {
                    for_each = actions.value.client_ip_header_parameters != null ? [actions.value.client_ip_header_parameters] : []
                    content {
                      switch      = client_ip_header_parameters.value.switch
                      header_name = client_ip_header_parameters.value.header_name
                    }
                  }

                  dynamic "ocsp_stapling_parameters" {
                    for_each = actions.value.ocsp_stapling_parameters != null ? [actions.value.ocsp_stapling_parameters] : []
                    content {
                      switch = ocsp_stapling_parameters.value.switch
                    }
                  }

                  dynamic "http2_parameters" {
                    for_each = actions.value.http2_parameters != null ? [actions.value.http2_parameters] : []
                    content {
                      switch = http2_parameters.value.switch
                    }
                  }

                  dynamic "post_max_size_parameters" {
                    for_each = actions.value.post_max_size_parameters != null ? [actions.value.post_max_size_parameters] : []
                    content {
                      switch   = post_max_size_parameters.value.switch
                      max_size = post_max_size_parameters.value.max_size
                    }
                  }

                  dynamic "client_ip_country_parameters" {
                    for_each = actions.value.client_ip_country_parameters != null ? [actions.value.client_ip_country_parameters] : []
                    content {
                      switch      = client_ip_country_parameters.value.switch
                      header_name = client_ip_country_parameters.value.header_name
                    }
                  }

                  dynamic "upstream_follow_redirect_parameters" {
                    for_each = actions.value.upstream_follow_redirect_parameters != null ? [actions.value.upstream_follow_redirect_parameters] : []
                    content {
                      switch    = upstream_follow_redirect_parameters.value.switch
                      max_times = upstream_follow_redirect_parameters.value.max_times
                    }
                  }

                  dynamic "upstream_request_parameters" {
                    for_each = actions.value.upstream_request_parameters != null ? [actions.value.upstream_request_parameters] : []
                    content {
                      dynamic "query_string" {
                        for_each = upstream_request_parameters.value.query_string != null ? [upstream_request_parameters.value.query_string] : []
                        content {
                          action = query_string.value.action
                          switch = query_string.value.switch
                          values = query_string.value.values
                        }
                      }
                      dynamic "cookie" {
                        for_each = upstream_request_parameters.value.cookie != null ? [upstream_request_parameters.value.cookie] : []
                        content {
                          action = cookie.value.action
                          switch = cookie.value.switch
                          values = cookie.value.values
                        }
                      }
                    }
                  }

                  dynamic "tls_config_parameters" {
                    for_each = actions.value.tls_config_parameters != null ? [actions.value.tls_config_parameters] : []
                    content {
                      cipher_suite = tls_config_parameters.value.cipher_suite
                      version      = tls_config_parameters.value.version
                    }
                  }

                  dynamic "modify_origin_parameters" {
                    for_each = actions.value.modify_origin_parameters != null ? [actions.value.modify_origin_parameters] : []
                    content {
                      origin_type       = modify_origin_parameters.value.origin_type
                      origin            = modify_origin_parameters.value.origin
                      origin_protocol   = modify_origin_parameters.value.origin_protocol
                      http_origin_port  = modify_origin_parameters.value.http_origin_port
                      https_origin_port = modify_origin_parameters.value.https_origin_port
                      private_access    = modify_origin_parameters.value.private_access
                      dynamic "private_parameters" {
                        for_each = modify_origin_parameters.value.private_parameters != null ? [modify_origin_parameters.value.private_parameters] : []
                        content {
                          access_key_id     = private_parameters.value.access_key_id
                          secret_access_key = private_parameters.value.secret_access_key
                          signature_version = private_parameters.value.signature_version
                          region            = private_parameters.value.region
                        }
                      }
                    }
                  }

                  dynamic "http_upstream_timeout_parameters" {
                    for_each = actions.value.http_upstream_timeout_parameters != null ? [actions.value.http_upstream_timeout_parameters] : []
                    content {
                      response_timeout = http_upstream_timeout_parameters.value.response_timeout
                    }
                  }

                  dynamic "http_response_parameters" {
                    for_each = actions.value.http_response_parameters != null ? [actions.value.http_response_parameters] : []
                    content {
                      status_code   = http_response_parameters.value.status_code
                      response_page = http_response_parameters.value.response_page
                    }
                  }

                  dynamic "error_page_parameters" {
                    for_each = actions.value.error_page_parameters != null ? [actions.value.error_page_parameters] : []
                    content {
                      dynamic "error_page_params" {
                        for_each = error_page_parameters.value.error_page_params != null ? error_page_parameters.value.error_page_params : []
                        content {
                          status_code  = error_page_params.value.status_code
                          redirect_url = error_page_params.value.redirect_url
                        }
                      }
                    }
                  }

                  dynamic "modify_response_header_parameters" {
                    for_each = actions.value.modify_response_header_parameters != null ? [actions.value.modify_response_header_parameters] : []
                    content {
                      dynamic "header_actions" {
                        for_each = modify_response_header_parameters.value.header_actions != null ? modify_response_header_parameters.value.header_actions : []
                        content {
                          action = header_actions.value.action
                          name   = header_actions.value.name
                          value  = header_actions.value.value
                        }
                      }
                    }
                  }

                  dynamic "modify_request_header_parameters" {
                    for_each = actions.value.modify_request_header_parameters != null ? [actions.value.modify_request_header_parameters] : []
                    content {
                      dynamic "header_actions" {
                        for_each = modify_request_header_parameters.value.header_actions != null ? modify_request_header_parameters.value.header_actions : []
                        content {
                          action = header_actions.value.action
                          name   = header_actions.value.name
                          value  = header_actions.value.value
                        }
                      }
                    }
                  }

                  dynamic "response_speed_limit_parameters" {
                    for_each = actions.value.response_speed_limit_parameters != null ? [actions.value.response_speed_limit_parameters] : []
                    content {
                      mode      = response_speed_limit_parameters.value.mode
                      max_speed = response_speed_limit_parameters.value.max_speed
                      start_at  = response_speed_limit_parameters.value.start_at
                    }
                  }

                  dynamic "set_content_identifier_parameters" {
                    for_each = actions.value.set_content_identifier_parameters != null ? [actions.value.set_content_identifier_parameters] : []
                    content {
                      content_identifier = set_content_identifier_parameters.value.content_identifier
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
