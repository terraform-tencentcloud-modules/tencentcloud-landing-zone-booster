locals {
  vpc_instances = [
    for item in tencentcloud_cfw_vpc_instance.vpc_instance.vpc_fw_instances : {
      instance_id   = item.fw_ins_id
      instance_name = item.name
      havip_infos = [
        for gw in item.fw_gateway : {
          gateway_id = gw.gateway_id
          vpc_id     = gw.vpc_id
          ip_address = gw.ip_address
        }
      ]
    }
  ]
}

resource "tencentcloud_cfw_vpc_instance" "vpc_instance" {
  name        = var.name
  mode        = var.mode
  switch_mode = var.switch_mode
  fw_vpc_cidr = var.fw_vpc_cidr
  ccn_id      = var.ccn_id

  dynamic "vpc_fw_instances" {
    for_each = var.vpc_fw_instances
    content {
      name    = vpc_fw_instances.value.name
      vpc_ids = vpc_fw_instances.value.vpc_ids

      dynamic "fw_deploy" {
        for_each = vpc_fw_instances.value.fw_deploy
        content {
          deploy_region = fw_deploy.value.deploy_region
          width         = fw_deploy.value.width
          zone_set      = fw_deploy.value.zone_set
          cross_a_zone  = fw_deploy.value.cross_a_zone
        }
      }
    }
  }
}
