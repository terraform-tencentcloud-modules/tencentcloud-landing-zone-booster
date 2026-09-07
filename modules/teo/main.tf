###############################################################################
### Edgeone Zone resource
###############################################################################
resource "tencentcloud_teo_zone" "zone" {
  zone_name       = var.edgeone_zone.zone_name
  type            = var.edgeone_zone.type
  area            = var.edgeone_zone.area
  alias_zone_name = var.edgeone_zone.alias_zone_name
  paused          = var.edgeone_zone.paused
  plan_id         = var.edgeone_zone.plan_id
  tags            = var.tags
}

###############################################################################
### The site acceleration global resource of Edgeone Zone 
###############################################################################
resource "tencentcloud_teo_l7_acc_setting" "l7_acc_setting" {
  count = length(var.l7_acc_setting) > 0 ? 1 : 0

  zone_id = tencentcloud_teo_zone.zone.id

  dynamic "zone_config" {
    for_each = var.l7_acc_setting
    content {
      dynamic "accelerate_mainland" {
        for_each = zone_config.value.accelerate_mainland != null ? [zone_config.value.accelerate_mainland] : []
        content {
          switch = accelerate_mainland.value.switch
        }
      }

      dynamic "cache" {
        for_each = zone_config.value.cache != null ? [zone_config.value.cache] : []
        content {
          dynamic "custom_time" {
            for_each = cache.value.custom_time != null ? [cache.value.custom_time] : []
            content {
              cache_time = custom_time.value.cache_time
              switch     = custom_time.value.switch
            }
          }
          dynamic "follow_origin" {
            for_each = cache.value.follow_origin != null ? [cache.value.follow_origin] : []
            content {
              switch                 = follow_origin.value.switch
              default_cache          = follow_origin.value.default_cache
              default_cache_strategy = follow_origin.value.default_cache_strategy
              default_cache_time     = follow_origin.value.default_cache_time
            }
          }
          dynamic "no_cache" {
            for_each = cache.value.no_cache != null ? [cache.value.no_cache] : []
            content {
              switch = no_cache.value.switch
            }
          }
        }
      }

      dynamic "cache_key" {
        for_each = zone_config.value.cache_key != null ? [zone_config.value.cache_key] : []
        content {
          full_url_cache = cache_key.value.full_url_cache
          ignore_case    = cache_key.value.ignore_case
          dynamic "query_string" {
            for_each = cache_key.value.query_string != null ? [cache_key.value.query_string] : []
            content {
              action = query_string.value.action
              switch = query_string.value.switch
              values = query_string.value.values
            }
          }
        }
      }

      dynamic "cache_prefresh" {
        for_each = zone_config.value.cache_prefresh != null ? [zone_config.value.cache_prefresh] : []
        content {
          switch             = cache_prefresh.value.switch
          cache_time_percent = cache_prefresh.value.cache_time_percent
        }
      }

      dynamic "client_ip_country" {
        for_each = zone_config.value.client_ip_country != null ? [zone_config.value.client_ip_country] : []
        content {
          switch      = client_ip_country.value.switch
          header_name = client_ip_country.value.header_name
        }
      }

      dynamic "client_ip_header" {
        for_each = zone_config.value.client_ip_header != null ? [zone_config.value.client_ip_header] : []
        content {
          switch      = client_ip_header.value.switch
          header_name = client_ip_header.value.header_name
        }
      }

      dynamic "compression" {
        for_each = zone_config.value.compression != null ? [zone_config.value.compression] : []
        content {
          switch     = compression.value.switch
          algorithms = compression.value.algorithms
        }
      }

      dynamic "force_redirect_https" {
        for_each = zone_config.value.force_redirect_https != null ? [zone_config.value.force_redirect_https] : []
        content {
          switch               = force_redirect_https.value.switch
          redirect_status_code = force_redirect_https.value.redirect_status_code
        }
      }

      dynamic "grpc" {
        for_each = zone_config.value.grpc != null ? [zone_config.value.grpc] : []
        content {
          switch = grpc.value.switch
        }
      }

      dynamic "hsts" {
        for_each = zone_config.value.hsts != null ? [zone_config.value.hsts] : []
        content {
          switch              = hsts.value.switch
          include_sub_domains = hsts.value.include_sub_domains
          preload             = hsts.value.preload
          timeout             = hsts.value.timeout
        }
      }

      dynamic "http2" {
        for_each = zone_config.value.http2 != null ? [zone_config.value.http2] : []
        content {
          switch = http2.value.switch
        }
      }

      dynamic "ipv6" {
        for_each = zone_config.value.ipv6 != null ? [zone_config.value.ipv6] : []
        content {
          switch = ipv6.value.switch
        }
      }

      dynamic "max_age" {
        for_each = zone_config.value.max_age != null ? [zone_config.value.max_age] : []
        content {
          follow_origin = max_age.value.follow_origin
          cache_time    = max_age.value.cache_time
        }
      }

      dynamic "ocsp_stapling" {
        for_each = zone_config.value.ocsp_stapling != null ? [zone_config.value.ocsp_stapling] : []
        content {
          switch = ocsp_stapling.value.switch
        }
      }

      dynamic "offline_cache" {
        for_each = zone_config.value.offline_cache != null ? [zone_config.value.offline_cache] : []
        content {
          switch = offline_cache.value.switch
        }
      }

      dynamic "post_max_size" {
        for_each = zone_config.value.post_max_size != null ? [zone_config.value.post_max_size] : []
        content {
          switch   = post_max_size.value.switch
          max_size = post_max_size.value.max_size
        }
      }

      dynamic "quic" {
        for_each = zone_config.value.quic != null ? [zone_config.value.quic] : []
        content {
          switch = quic.value.switch
        }
      }

      dynamic "smart_routing" {
        for_each = zone_config.value.smart_routing != null ? [zone_config.value.smart_routing] : []
        content {
          switch = smart_routing.value.switch
        }
      }

      dynamic "standard_debug" {
        for_each = zone_config.value.standard_debug != null ? [zone_config.value.standard_debug] : []
        content {
          switch               = standard_debug.value.switch
          allow_client_ip_list = standard_debug.value.allow_client_ip_list
          expires              = standard_debug.value.expires
        }
      }

      dynamic "tls_config" {
        for_each = zone_config.value.tls_config != null ? [zone_config.value.tls_config] : []
        content {
          cipher_suite = tls_config.value.cipher_suite
          version      = tls_config.value.version
        }
      }

      dynamic "upstream_http2" {
        for_each = zone_config.value.upstream_http2 != null ? [zone_config.value.upstream_http2] : []
        content {
          switch = upstream_http2.value.switch
        }
      }

      dynamic "web_socket" {
        for_each = zone_config.value.web_socket != null ? [zone_config.value.web_socket] : []
        content {
          switch  = web_socket.value.switch
          timeout = web_socket.value.timeout
        }
      }
    }
  }
}
