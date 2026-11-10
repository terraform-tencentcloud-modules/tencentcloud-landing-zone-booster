locals {
  attached_instance = {
    vpc_ids           = [for attached in var.accept_attach_instances : attached.instance_id if attached.instance_type == "VPC"],
    bmvpc_ids         = [for attached in var.accept_attach_instances : attached.instance_id if attached.instance_type == "BMVPC"],
    vpngw_ids         = [for attached in var.accept_attach_instances : attached.instance_id if attached.instance_type == "VPNGW"],
    directconnect_ids = [for attached in var.accept_attach_instances : attached.instance_id if attached.instance_type == "DIRECTCONNECT"],
  }
  ccn_id = var.ccn_id != "" ? var.ccn_id : try(data.tencentcloud_ccn_instances.ccn.instance_list.0.ccn_id, null)
}

data "tencentcloud_ccn_instances" "ccn" {
  name = var.ccn_name
}

resource "tencentcloud_ccn_instances_accept_attach" "accept" {
  ccn_id = local.ccn_id
  dynamic "instances" {
    for_each = var.accept_attach_instances
    content {
      instance_id     = instances.value.instance_id
      instance_region = instances.value.instance_region
      instance_type   = instances.value.instance_type
    }
  }
}