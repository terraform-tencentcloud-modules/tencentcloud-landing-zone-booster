####################################################################
# CHECK: Listener Certificate Configuration
####################################################################
locals {
  has_certificate = var.certificate != null
  has_multi_cert  = try(length(var.multi_cert_info), 0) > 0
}

check "listener_cert_required" {
  assert {
    condition = !(
      (var.protocol == "TCP_SSL" || (var.protocol == "HTTPS" && !coalesce(var.certificate.sni_switch, false)))
      && !local.has_certificate
      && !local.has_multi_cert
    )
    error_message = "A TCP_SSL/HTTPS (SNI disabled) listener must specify either certificate or multi_cert_info."
  }
}

####################################################################
# CLB (Cloud Load Balancer) Listener Configuration
####################################################################
variable "clb_id" {
  description = "The ID of the Cloud Load Balancer instance where the listener will be created"
  type        = string
}

variable "listener_name" {
  description = "Friendly name for the load balancer listener (will appear in console)"
  type        = string
  default     = "tf-clb-listener"  # Default name if not specified
}

variable "port" {
  description = "The port number on which the listener will accept traffic (valid range: 1-65535)"
  type        = number
  default     = null
  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "Port must be between 1 and 65535"
  }
}

variable "protocol" {
  description = "Type of protocol within the listener. Valid values: `TCP`, `UDP`, `HTTP`, `HTTPS`, `TCP_SSL` and `QUIC`. Options: HTTP/HTTPS for Layer 7, TCP/UDP for Layer 4"
  type        = string
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "UDP", "TCP_SSL", "QUIC"], var.protocol)
    error_message = "Protocol must be one of: `HTTP`, `HTTPS`, `TCP`, `UDP`, `TCP_SSL` and `QUIC`"
  }
}

variable "scheduler" {
  description = "Scheduling method of the CLB listener, and available values are 'WRR' and 'LEAST_CONN'. The default is 'WRR'. NOTES: The listener of `HTTP` and `HTTPS` protocol additionally supports the `IP Hash` method. NOTES: TCP/UDP/TCP_SSL listener allows direct configuration, HTTP/HTTPS listener needs to be configured in `tencentcloud_clb_listener_rule`"
  type        = string
  default     = "WRR"  # Default traffic distribution method
  validation {
    condition     = contains(["WRR", "LEAST_CONN"], var.scheduler)
    error_message = "Scheduler must be one of: WRR, LEAST_CONN"
  }
}

variable "target_type" {
  description = "Backend target type. Valid values: `NODE`, `TARGETGROUP`. `NODE` means to bind ordinary nodes, `TARGETGROUP` means to bind target group. NOTES: TCP/UDP/TCP_SSL listener must configuration, HTTP/HTTPS listener needs to be configured in tencentcloud_clb_listener_rule."
  type        = string
  default     = "TARGETGROUP"  # Recommended modern approach
  validation {
    condition     = contains(["NODE", "TARGETGROUP"], var.target_type)
    error_message = "Target type must be one of: NODE, TARGETGROUP"
  }
}

variable "session_expire_time" {
  description = "Time of session persistence within the CLB listener. NOTES: Available when scheduler is specified as `WRR`, and not available when listener protocol is `TCP_SSL`. NOTES: TCP/UDP/TCP_SSL listener allows direct configuration, HTTP/HTTPS listener needs to be configured in `tencentcloud_clb_listener_rule`"
  type        = number
  default     = null
  validation {
    condition     = var.session_expire_time == null || (var.session_expire_time >= 30 && var.session_expire_time <= 3600)
    error_message = "Session Expire Time must be between 30 and 3600"
  }
}

variable "keepalive_enable" {
  description = "Whether to enable persistent connection (long connection). Only applicable to `HTTP`/`HTTPS` listeners. Valid values: `0` (disable, default), `1` (enable). This feature is currently in beta."
  type        = number
  default     = null
}

variable "snat_enable" {
  description = "Whether to enable SNAT (source IP replacement). `true`: enable, `false`: disable (default). Note: when SNAT is enabled, the client source IP is replaced and the pass-through client source IP option is disabled, and vice versa."
  type        = bool
  default     = false
}

variable "certificate" {
  description = "SSL/TLS certificate configuration (required for HTTPS listeners)"
  type = object({
    ssl_mode   = optional(string) # Encryption mode: UNIDIRECTIONAL (server auth only) or MUTUAL (mTLS)
    cert_id    = optional(string) # ID of the server certificate uploaded to Tencent Cloud
    cert_ca_id = optional(string) # ID of client CA certificate for mutual authentication
    sni_switch = optional(bool)   # Indicates whether SNI is enabled, and only supported with protocol `HTTPS`. If enabled, you can set a certificate for each rule in `tencentcloud_clb_listener_rule`, otherwise all rules have a certificate.
  })
  default = null  # No certificate by default (only needed for HTTPS)
  # ssl_mode
  validation {
    condition     = var.certificate == null || contains(["UNIDIRECTIONAL", "MUTUAL"], coalesce(var.certificate.ssl_mode, "UNIDIRECTIONAL"))
    error_message = "certificate.ssl_mode only UNIDIRECTIONAL or MUTUAL。"
  }
  # MUTUAL(mTLS) must have cert_ca_id
  validation {
    condition     = var.certificate == null || var.certificate.ssl_mode != "MUTUAL" || var.certificate.cert_ca_id != null
    error_message = "ssl_mode is MUTUAL，certificate.cert_ca_id must be specified"
  }
}

variable "multi_cert_info" {
  description = "Certificate information, supporting multiple server certificates with different algorithm types at the same time. Only applicable to `TCP_SSL` listeners and `HTTPS` listeners with SNI disabled. When creating a `TCP_SSL` listener or an `HTTPS` listener with SNI disabled, at least one of `certificate`/`multi_cert_info` must be specified, but they cannot be specified at the same time."
  type = list(object({
    ssl_mode     = optional(string, "UNIDIRECTIONAL") # Authentication type. Values: UNIDIRECTIONAL (one-way authentication), MUTUAL (two-way authentication).
    cert_id_list = list(string) # List of server certificate ID.
  }))
  default = null
}

variable "health_check" {
  description = "Configuration for checking backend server health (TCP/UDP protocols only)"
  type = object({
    enabled        = optional(bool, true) # Whether health checks are active
    check_type     = optional(string)     # Check method: TCP (connect), HTTP, or CUSTOM
    port           = optional(number)     # The health check port is the port of the backend service by default. Unless you want to specify a specific port, it is recommended to leave it blank. Only applicable to TCP/UDP listener.
    interval_time  = optional(number)     # Seconds between checks (default: 5s)
    http_code      = optional(number)     # HTTP health check code of TCP listener
    http_domain    = optional(string)     # HTTP health check domain of TCP listener
    http_method    = optional(string)     # HTTP health check method of TCP listener. Valid values: `HEAD`, `GET`
    http_path      = optional(string)     # HTTP health check path of TCP listener
    http_version   = optional(string)     # The HTTP version of the backend service. When the value of `health_check_type` of the health check protocol is `HTTP`, this field is required. Valid values: `HTTP/1.0`, `HTTP/1.1`
    health_num     = optional(number)     # Health threshold of health check, and the default is `3`
    unhealth_num   = optional(number)     # Unhealthy threshold of health check, and the default is `3`
    time_out       = optional(number)     # Response timeout of health check. Valid value ranges: [2~60] sec. Default is 2 sec. Response timeout needs to be less than check interval. NOTES: Only supports listeners of `TCP`,`UDP`,`TCP_SSL` protocol
    context_type   = optional(string)     # For CUSTOM checks: TEXT or HEX format
    send_context   = optional(string)     # Request content to send (CUSTOM checks)
    recv_context   = optional(string)     # Expected response content (CUSTOM checks)
    source_ip_type = optional(number)     # Specifies the type of health check source IP. `0` (default): CLB VIP. `1`: 100.64 IP range
  })
  default = null  # No health check by default unless specified
}

variable "listener_target_instance" {
  description = "Target group instances to bind to the listener"
  type = object({
    enabled = optional(bool, false) # Whether to enable target group binding
    targets = list(object({         # targets to bind to the listener
      instance_id = optional(string, "")
      eni_ip      = optional(string, "")
      port        = number
      weight      = optional(number, 10)
    }))
  })
  default = null  # No target group binding by default
}

####################################################################
# HTTP/HTTPS Listener Rule Configuration
####################################################################
variable "listener_rules" {
  description = "List of routing rules for Layer 7 (HTTP/HTTPS) listeners"
  type = list(object({
    domain              = string           # Domain name to match (e.g., example.com)
    url                 = string           # URL path pattern (default: root path)
    session_expire_time = optional(number) # Session persistence duration in seconds
    http2_switch        = optional(bool)   # Indicate to apply HTTP2.0 protocol or not.
    scheduler           = optional(string, "WRR")  # Rule-specific traffic distribution
    target_type         = optional(string, "NODE") # Backend reference method
    forward_type        = optional(string, "HTTP") # Forwarding protocol
    quic                = optional(bool, false)    # Whether to enable QUIC. Note: QUIC can be enabled only for HTTPS domain names.

    certificate = optional(object({
      ssl_mode   = optional(string) # Encryption mode: UNIDIRECTIONAL (server auth only) or MUTUAL (mTLS)
      cert_id    = optional(string) # ID of the server certificate uploaded to Tencent Cloud
      cert_ca_id = optional(string) # ID of client CA certificate for mutual authentication
    }))

    health_check = optional(object({
      enabled             = optional(bool, true)     # Enable health checks for this rule with property "health_check_switch"
      type                = optional(string, "HTTP") # Type of health check. Valid value is `CUSTOM`, `PING`, `TCP`, `HTTP`, `HTTPS`, `GRPC`, `GRPCS`.
      path                = optional(string, "/")    # HTTP check path
      domain              = optional(string)         # Host header for HTTP checks
      timeout             = optional(number, 2)     # Timeout in seconds
      interval            = optional(number, 5)      # Check interval in seconds
      healthy_threshold   = optional(number, 3)      # Success threshold count
      unhealthy_threshold = optional(number, 3)      # Failure threshold count
      http_code           = optional(number, 2)      # Expected HTTP status codes (2=2xx)
      method              = optional(string, "GET")  # HTTP request method
      source_ip_type      = optional(number, 1)      # Specifies the type of health check source IP. `0` (default): CLB VIP. `1`: 100.64 IP range.
    }), {})

    target_instance = object({
      enabled = optional(bool, false) # Whether to enable target group binding
      targets = list(object({         # targets to bind to the listener
        instance_id = optional(string, "")
        eni_ip      = optional(string, "")
        port        = number
        weight      = optional(number, 10)
      }))
    })
  }))
  default = []  # Empty list means no rules (basic listener only)
}