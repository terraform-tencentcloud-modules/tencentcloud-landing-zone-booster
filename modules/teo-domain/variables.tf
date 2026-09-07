###############################################################################
### Edgeone Zone acceleration domains and ssl certificate variables
###############################################################################
variable "edgeone_zone_id" {
  description = "ID of EdgeOne zone"
  type        = string
  default     = ""
}

variable "acc_domain" {
  description = "Acceleration domain"
  type = object({
    domain_name       = string                     # Accelerated domain name.
    http_origin_port  = optional(number, 80)       # HTTP back-to-origin port, if not filled in, the default value is 80.
    https_origin_port = optional(number, 443)      # TTPS back-to-origin port. 
    ipv6_status       = optional(string, "follow") # IPv6 status.the value is: follow: follow the site IPv6 configuration; on: on; off: off. If not filled in, the default is: follow.
    origin_protocol   = string                     # Origin return protocol, possible values are: FOLLOW: protocol follow; HTTP: HTTP protocol back to source; HTTPS: HTTPS protocol back to source. If not filled in, the default is: FOLLOW.
    origin_info = list(object({                    # The origin info.
      origin_type    = string                      # The origin type. Values: IP_DOMAIN: IPv4/IPv6 address or domain name; COS: COS bucket address; ORIGIN_GROUP: Origin group; AWS_S3: AWS S3 bucket address; SPACE: EdgeOne Shield Space.
      origin         = string                      # The origin address.
      host_header    = optional(string)            # Customize the back-to-origin HOST header. This parameter is only valid when OriginType=IP_DOMAIN. If OriginType=COS or AWS_S3, the back-to-origin HOST header will be consistent with the origin server domain name.
      backup_origin  = optional(string)            # ID of the secondary origin group (valid when OriginType=ORIGIN_GROUP)
      private_access = optional(string)            # Whether to authenticate access to the private object storage origin (valid when OriginType=COS/AWS_S3). Values: on: Enable private authentication; off: Disable private authentication. If this field is not specified, the default value off is used.
      private_parameters = optional(list(object({  # The private authentication parameters. This field is valid when PrivateAccess=on
        name  = string                             # The parameter name. Valid values: AccessKeyId: Access Key ID; SecretAccessKey: Secret Access Key.
        value = string                             # The parameter value.
      })))
    }))
  })
  default = null
}
