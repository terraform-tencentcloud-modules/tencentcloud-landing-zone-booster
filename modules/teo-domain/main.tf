###############################################################################
### Edgeone Zone acceleration domain resource
###############################################################################
resource "tencentcloud_teo_acceleration_domain" "domain" {
  count = var.acc_domain != null ? 1 : 0

  zone_id           = var.edgeone_zone_id
  domain_name       = var.acc_domain.domain_name
  http_origin_port  = var.acc_domain.http_origin_port
  https_origin_port = var.acc_domain.https_origin_port
  ipv6_status       = var.acc_domain.ipv6_status
  origin_protocol   = var.acc_domain.origin_protocol

  dynamic "origin_info" {
    for_each = var.acc_domain.origin_info
    content {
      origin         = origin_info.value.origin
      origin_type    = origin_info.value.origin_type
      host_header    = origin_info.value.origin_type == "IP_DOMAIN" ? origin_info.value.host_header == null ? origin_info.value.origin : origin_info.value.host_header : null
      backup_origin  = origin_info.value.backup_origin
      private_access = origin_info.value.origin_type == "COS" || origin_info.value.origin_type == "AWS_S3" ? origin_info.value.private_access : null
      dynamic "private_parameters" {
        for_each = origin_info.value.private_parameters == null ? [] : origin_info.value.private_parameters
        content {
          name  = private_parameters.value.name
          value = private_parameters.value.value
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [origin_info[0].private_parameters]
  }
}
