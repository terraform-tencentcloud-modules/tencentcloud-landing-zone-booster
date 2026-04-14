################################################################################
# Waf clb domain vars
################################################################################

variable "instance_id" {
  description = "Instance unique ID"
  type        = string
}

variable "domain" {
  description = "Domain name."
  type        = string
}

variable "is_cdn" {
  description = "Whether a proxy has been enabled before WAF"
  type        = number
  default     = 0
}

variable "status" {
  description = "Binding status between waf and LB, 0:not bind, 1:binding."
  type        = number
  default     = 1
}

variable "engine" {
  description = "Protection Status."
  type        = number
  default     = 20
}

variable "region" {
  description = "Regions of LB bound by domain."
  type        = string
}

variable "flow_mode" {
  description = "WAF traffic mode, 1 cleaning mode, 0 mirroring mode."
  type        = number
  default     = 1
}

variable "alb_type" {
  description = "Load balancer type: clb, apisix or tsegw, default clb."
  type        = string
  default     = "clb"
}

variable "bot_status" {
  description = "Whether to enable bot, 1 enable, 0 disable."
  type        = number
  default     = 0
}

variable "api_safe_status" {
  description = "Whether to enable api safe, 1 enable, 0 disable."
  type        = number
  default     = 0
}

variable "ip_headers" {
  description = "When is_cdn=3, this parameter needs to be filled in to indicate a custom header."
  type        = list(string)
  default     = []
}

variable "load_balancer_set" {
  description = "List of bound LB."
  type = list(object({
    load_balancer_id   = string
    load_balancer_name = string
    listener_id        = string
    listener_name      = string
    vip                = string
    vport              = number
    region             = string
    protocol           = string
    zone               = string
    load_balancer_type = string
  }))
  default = []
}
