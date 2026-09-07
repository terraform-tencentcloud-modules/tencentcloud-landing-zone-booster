###############################################################################
### Edgeone Zone ssl certificate variables
###############################################################################
variable "edgeone_zone_id" {
  description = "ID of EdgeOne zone"
  type        = string
  default     = ""
}

variable "ssl_cert" {
  description = "EdgeOne SSL certificate"
  type = object({
    host = string                             # Acceleration domain name that needs to modify the certificate configuration.
    mode = string                             # Mode of configuring the certificate, the values are: disable: Do not configure the certificate; eofreecert: Configure EdgeOne free certificate; sslcert: Configure SSL certificate. If not filled in, the default value is disable.
    server_cert_info = optional(list(object({ # SSL certificate configuration, this parameter takes effect only when mode = sslcert, just enter the corresponding CertId. You can go to the SSL certificate list to view the CertId.
      cert_id     = string                    # ID of the server certificate.
      alias       = optional(string)          # Alias of the certificate.
      type        = optional(string)          # Type of the certificate. Values: default: Default certificate; upload: Specified certificate; managed: Tencent Cloud-managed certificate. Note: This field may return null, indicating that no valid value can be obtained.
      common_name = string                    # Domain name of the certificate. 
      deploy_time = optional(string)          # Time when the certificate is deployed.
      expire_time = optional(string)          # Time when the certificate expires.
      sign_algo   = optional(string)          # Signature algorithm.
    })))
    timeouts = optional(object({
      create = optional(string, "20m") # Timeout for creating the certificate config.
      update = optional(string, "20m") # Timeout for updating the certificate config.
    }), {})
  })
}


