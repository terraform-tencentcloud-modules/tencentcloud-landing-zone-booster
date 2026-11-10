variable "domain" {
  description = "(Required) Domain name."
  type        = string
}

variable "instance_id" {
  description = "(Required) WAF instance ID."
  type        = string
}

variable "ports" {
  description = "(Required) Port configuration for the domain."
  type = list(object({
    port          = string
    protocol      = string
    upstream_port = string
    upstream_protocol = string
  }))
  default = [
    {
      port          = "80"
      protocol      = "http"
      upstream_port = "80"
      upstream_protocol = "http"
    }
  ]
}

# optional parameters
variable "active_check" {
  description = "(Optional, Int) Whether to enable active health detection, 0 represents disable and 1 represents enable."
  type        = number
  default     = 0
}

variable "api_safe_status" {
  description = "(Optional, Int) Whether to enable api safe, 1 enable, 0 disable."
  type        = number
  default     = 0
}

variable "bot_status" {
    description = "(Optional, Int) Whether to enable bot, 1 enable, 0 disable."
    type        = number
    default     = 0
}
variable "cert_type"{
    description = "(Optional, Int) Certificate type, 0 represents no certificate, CertType=1 represents self owned certificate, and 2 represents managed certificate."
    type        = number
    default     = 0
}

variable "cert" {
  description = "(Optional, String) Certificate content, When CertType=2, this parameter needs to be filled."
  type        = string
  default     = null
  sensitive   = true
}

variable "cipher_template"{
    description = "(Optional, Int) Encryption Suite Template, 0:default 1:Universal template 2:Security template 3:Custom template."
    type        = number
    default     = 1
}

variable "ciphers"{
    description = "(Optional, List: [Int]) Encryption Suite Information."
    type        = list(number)
    default     = []
}

variable "cls_status"{
    description = "(Optional, Int) Whether to enable access logs, 1 enable, 0 disable."
    type        = number
    default     = 0
}

variable "https_rewrite"{
    description = "(Optional, Int) Whether to enable http to https redirect, 1 enable, 0 disable."
    type        = number
    default     = 0
}

variable "https_upstream_port"{
    description = "(Optional, String) Upstream port for https, When listen ports has https port and UpstreamScheme is HTTP, the current field needs to be filled."
    type        = string
    default     = null
}

variable "ip_headers"{
    description = "(Optional, List: [String]) When is_cdn=3, this parameter needs to be filled in to indicate a custom header."
    type        = list(string)
    default     = []
}

variable "is_cdn"{
    description = "(Optional, Int) Whether a proxy has been enabled before WAF, 0 no deployment, 1 deployment and use first IP in X-Forwarded-For as client IP, 2 deployment and use remote_addr as client IP, 3 deployment and use values of custom headers as client IP."
    type        = number
    default     = 0
}

variable "is_http2"{
    description = "(Optional, Int) Whether to enable HTTP2, Enabling HTTP2 requires HTTPS support, 1 means enabled, 0 does not."
    type        = number
    default     = 0
}

variable "is_keep_alive"{
    description = "(Optional, String) Whether to enable keep-alive, 0 disable, 1 enable"
    type        = string
    default     = "0"
}

variable "is_websocket"{
    description = "(Optional, Int) Is WebSocket support enabled. 1 means enabled, 0 does not."
    type        = number
    default     = 0
}

variable "load_balance"{
    description = "(Optional, String) Load balancing strategy, where 0 represents polling and 1 represents IP hash and 2 weighted round robin."
    type        = string
    default     = "0"
}

variable "private_key"{
    description = "(Optional, String) Certificate key, When CertType=1, this parameter needs to be filled."
    type        = string
    default     = null
    sensitive   = true
}

variable "proxy_read_timeout" {
  description = "(Optional, Int) Proxy read timeout in seconds."
  type        = number
  default     = 300
}

variable "proxy_send_timeout" {
  description = "(Optional, Int) Proxy send timeout in seconds."
  type        = number
  default     = 300
}

variable "sni_host" {
  description = "(Optional, String) When SniType=3, this parameter needs to be filled in to represent a custom host."
  type        = string
  default     = null
}

variable "sni_type" {
  description = "(Optional, Int) Sni type fo upstream, 0:disable SNI; 1:enable SNI and SNI equal original request host; 2:and SNI equal upstream host 3:enable SNI and equal customize host."
  type        = number
  default     = 0
}

variable "src_list" {
  description = "(Optional, List: [String]) Upstream IP List, When UpstreamType=0, this parameter needs to be filled."
  type        = list(string)
  default     = []
}

variable "ssl_id" {
  description = "(Optional, String) Certificate ID, When CertType=2, this parameter needs to be filled."
  type        = string
  default     = null
}

variable "status" {
  description = "(Optional, Int) WAF switch status, 1: turn on WAF switch; 0: turn off WAF switch."
  type        = number
  default     = 1
}

variable "tls_version" {
  description = "(Optional, Int) Version of TLS Protocol."
  type        = number
  default     = 3
}

variable "upstream_domain" {
  description = "(Optional, String) Upstream domain, When UpstreamType=1, this parameter needs to be filled."
  type        = string
  default     = null
}

variable "upstream_scheme" {
  description = "(Optional, String) Upstream scheme for https, http or https."
  type        = string
  default     = "http"
}

variable "upstream_type" {
  description = "(Optional, Int) Upstream type, 0 represents IP, 1 represents domain name."
  type        = number
  default     = 0
}

variable "weights" {
  description = "(Optional, List: [Int]) Weight of each upstream"
  type        = list(number)
  default     = []
}

variable "xff_reset" {
  description = "(Optional, Int) 0:disable xff reset; 1:enable xff reset."
  type        = number
  default     = 0
}