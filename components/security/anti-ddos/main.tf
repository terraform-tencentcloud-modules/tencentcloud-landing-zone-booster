locals {
  instance_charge_prepaid = var.instance_charge_type == "POSTPAID_BY_MONTH" ? [{
    period     = var.instance_charge_prepaid_period
    renew_flag = var.instance_charge_prepaid_renew_flag
  }] : []

  standard_package_config = var.package_type == "Standard" ? [{
    region                 = var.standard_region
    protect_ip_count       = var.standard_protect_ip_count
    bandwidth              = var.standard_bandwidth
    elastic_bandwidth_flag = var.standard_elastic_bandwidth_flag
  }] : []

  standard_plus_package_config = var.package_type == "StandardPlus" ? [{
    region                 = var.standard_plus_region
    protect_count          = var.standard_plus_protect_count
    protect_ip_count       = var.standard_plus_protect_ip_count
    bandwidth              = var.standard_plus_bandwidth
    elastic_bandwidth_flag = var.standard_plus_elastic_bandwidth_flag
  }] : []

  enterprise_package_config = var.package_type == "Enterprise" ? [{
    region                    = var.enterprise_region
    protect_ip_count          = var.enterprise_protect_ip_count
    basic_protect_bandwidth   = var.enterprise_basic_protect_bandwidth
    bandwidth                 = var.enterprise_bandwidth
    elastic_protect_bandwidth = var.enterprise_elastic_protect_bandwidth
    elastic_bandwidth_flag    = var.enterprise_elastic_bandwidth_flag
  }] : []
}

resource "tencentcloud_antiddos_bgp_instance" "this" {
  instance_charge_type = var.instance_charge_type
  package_type         = var.package_type

  dynamic instance_charge_prepaid {
    for_each = { for idx, item in local.instance_charge_prepaid : idx => item }
    content {
      period     = instance_charge_prepaid.value.period
      renew_flag = instance_charge_prepaid.value.renew_flag
    }
  }

  dynamic standard_package_config {
    for_each = { for idx, item in local.standard_package_config : idx => item }
    content {
      region                 = standard_package_config.value.region
      protect_ip_count       = standard_package_config.value.protect_ip_count
      bandwidth              = standard_package_config.value.bandwidth
      elastic_bandwidth_flag = standard_package_config.value.elastic_bandwidth_flag
    }
  }

  dynamic standard_plus_package_config {
    for_each = { for idx, item in local.standard_plus_package_config : idx => item }
    content {
      region                 = standard_plus_package_config.value.region
      protect_count          = standard_plus_package_config.value.protect_count
      protect_ip_count       = standard_plus_package_config.value.protect_ip_count
      bandwidth              = standard_plus_package_config.value.bandwidth
      elastic_bandwidth_flag = standard_plus_package_config.value.elastic_bandwidth_flag
    }
  }

  dynamic enterprise_package_config {
    for_each = { for idx, item in local.enterprise_package_config : idx => item }
    content {
      region                    = enterprise_package_config.value.region
      protect_ip_count          = enterprise_package_config.value.protect_ip_count
      basic_protect_bandwidth   = enterprise_package_config.value.basic_protect_bandwidth
      bandwidth                 = enterprise_package_config.value.bandwidth
      elastic_protect_bandwidth = enterprise_package_config.value.elastic_protect_bandwidth
      elastic_bandwidth_flag    = enterprise_package_config.value.elastic_bandwidth_flag
    }
  }

  dynamic tag_info_list {
    for_each = { for idx, item in var.tag_info_list : idx => item }
    content {
      tag_key   = tag_info_list.value.key
      tag_value = tag_info_list.value.value
    }
  }
}